/**
 * Handoff extension - transfer context to a new focused session
 *
 * Instead of compacting (which is lossy), handoff extracts what matters
 * for your next task and creates a new session with a generated prompt.
 *
 * Usage:
 *   /handoff now implement this for teams as well
 *   /handoff --session 01a040e0 pick up the pyapp service account work
 *
 * The generated context, followed by your message verbatim, appears as a draft
 * in the editor for review/editing.
 * The new session runs in the directory pi was started in.
 *
 * LOCAL PATCH (not upstream): `--session <id>` hands off from any session by ID
 * prefix, across all projects, instead of the current one.
 */

import { readFileSync } from "node:fs";
import type { AgentMessage } from "@earendil-works/pi-agent-core";
import { type Message, uuidv7 } from "@earendil-works/pi-ai";
import type { ExtensionAPI, SessionEntry } from "@earendil-works/pi-coding-agent";
import {
	BorderedLoader,
	buildContextEntries,
	convertToLlm,
	parseSessionEntries,
	serializeConversation,
	SessionManager,
} from "@earendil-works/pi-coding-agent";

const SYSTEM_PROMPT = `You are a context transfer assistant. Given a conversation history and the user's goal for a new thread, write ONLY the background context the new thread needs to act on that goal:

1. Relevant decisions made, approaches taken, key findings
2. Relevant files that were discussed or modified
3. Enough detail to be self-contained - the new thread cannot see the old conversation

The user's own words stating the task will be appended verbatim after your output. Do NOT restate, rephrase, summarize, or interpret the task. Do not write a "Task" or "Next steps" section. Do not include preamble like "Here's the context".

Output format:
## Context
We've been working on X. Key decisions:
- Decision 1
- Decision 2

Files involved:
- path/to/file1.ts
- path/to/file2.ts`;

// LOCAL PATCH: /handoff [--session <id>] <goal>
function splitArgs(args: string): { sessionId?: string; goal: string } {
	const match = args.match(/^--session\s+(\S+)\s+([\s\S]+)$/);
	return match ? { sessionId: match[1], goal: match[2].trim() } : { goal: args };
}

// LOCAL PATCH: active branch of any session, found by ID prefix across all projects.
async function loadBranchById(sessionId: string): Promise<SessionEntry[] | undefined> {
	const sessions = await SessionManager.listAll();
	const found = sessions.find((session) => session.id.startsWith(sessionId));
	if (!found) return undefined;
	const entries = parseSessionEntries(readFileSync(found.path, "utf8"));
	return buildContextEntries(entries.filter((entry): entry is SessionEntry => entry.type !== "session"));
}

function entryToMessage(entry: SessionEntry): AgentMessage | undefined {
	if (entry.type === "message") {
		return entry.message;
	}
	if (entry.type === "compaction") {
		return {
			role: "compactionSummary",
			summary: entry.summary,
			tokensBefore: entry.tokensBefore,
			timestamp: new Date(entry.timestamp).getTime(),
		};
	}
	return undefined;
}

function getHandoffMessages(branch: SessionEntry[]): AgentMessage[] {
	let compactionIndex = -1;
	for (let i = branch.length - 1; i >= 0; i--) {
		if (branch[i].type === "compaction") {
			compactionIndex = i;
			break;
		}
	}
	if (compactionIndex < 0) {
		return branch.map(entryToMessage).filter((message) => message !== undefined);
	}

	const compaction = branch[compactionIndex];
	const firstKeptIndex =
		compaction.type === "compaction" ? branch.findIndex((entry) => entry.id === compaction.firstKeptEntryId) : -1;
	const compactedBranch = [
		compaction,
		...(firstKeptIndex >= 0 ? branch.slice(firstKeptIndex, compactionIndex) : []),
		...branch.slice(compactionIndex + 1),
	];
	return compactedBranch.map(entryToMessage).filter((message) => message !== undefined);
}

export default function (pi: ExtensionAPI) {
	pi.registerCommand("handoff", {
		description: "[--session <id>] Transfer context to a new focused session",
		handler: async (args, ctx) => {
			if (ctx.mode !== "tui") {
				ctx.ui.notify("handoff requires interactive mode", "error");
				return;
			}

			if (!ctx.model) {
				ctx.ui.notify("No model selected", "error");
				return;
			}

			// LOCAL PATCH: optional session ID selects the source session.
			const { sessionId, goal } = splitArgs(args.trim());
			if (!goal) {
				ctx.ui.notify("Usage: /handoff [--session <id>] <goal for new thread>", "error");
				return;
			}

			// Gather conversation context from current branch. If the branch was compacted,
			// include the compaction summary plus entries from firstKeptEntryId onward.
			// LOCAL PATCH: --session reads that branch from another session file instead.
			const branch = sessionId ? await loadBranchById(sessionId) : ctx.sessionManager.getBranch();
			if (!branch) {
				ctx.ui.notify(`No session found with ID starting "${sessionId}"`, "error");
				return;
			}
			const messages = getHandoffMessages(branch);

			if (messages.length === 0) {
				ctx.ui.notify("No conversation to hand off", "error");
				return;
			}

			// Convert to LLM format and serialize
			const llmMessages = convertToLlm(messages);
			const conversationText = serializeConversation(llmMessages);
			const currentSessionFile = ctx.sessionManager.getSessionFile();

			// Generate the handoff prompt with loader UI
			const result = await ctx.ui.custom<string | null>((tui, theme, _kb, done) => {
				const loader = new BorderedLoader(tui, theme, `Generating handoff prompt...`);
				loader.onAbort = () => done(null);

				const doGenerate = async () => {
					const userMessage: Message = {
						role: "user",
						content: [
							{
								type: "text",
								text: `## Conversation History\n\n${conversationText}\n\n## User's Goal for New Thread\n\n${goal}`,
							},
						],
						timestamp: Date.now(),
					};

					const response = await ctx.modelRegistry.complete(
						ctx.model!,
						{ systemPrompt: SYSTEM_PROMPT, messages: [userMessage] },
						{
							signal: loader.signal,
							cacheRetention: "none",
							sessionId: uuidv7(),
						},
					);

					if (response.stopReason === "aborted") {
						return null;
					}

					const context = response.content
						.filter((c): c is { type: "text"; text: string } => c.type === "text")
						.map((c) => c.text)
						.join("\n")
						.trim();

					return `${context}\n\n---\n\n${goal}`;
				};

				doGenerate()
					.then(done)
					.catch((err) => {
						console.error("Handoff generation failed:", err);
						done(null);
					});

				return loader;
			});

			if (result === null) {
				ctx.ui.notify("Cancelled", "info");
				return;
			}

			// Let user edit the generated prompt
			const editedPrompt = await ctx.ui.editor("Edit handoff prompt", result);

			if (editedPrompt === undefined) {
				ctx.ui.notify("Cancelled", "info");
				return;
			}

			// Create new session with parent tracking. Use the replacement-session
			// context for post-switch UI work; the original ctx is stale after a
			// successful session replacement.
			const newSessionResult = await ctx.newSession({
				parentSession: currentSessionFile,
				withSession: async (replacementCtx) => {
					replacementCtx.ui.setEditorText(editedPrompt);
					replacementCtx.ui.notify("Handoff ready. Submit when ready.", "info");
				},
			});

			if (newSessionResult.cancelled) {
				ctx.ui.notify("New session cancelled", "info");
			}
		},
	});
}
