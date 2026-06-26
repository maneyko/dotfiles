local utils = require("config.utils")

local function fname(bufnr)
  return vim.api.nvim_buf_get_name(bufnr):gsub("\\", "/")
end

local function has(bufnr, substr)
  return utils.substr_exists(fname(bufnr), substr)
end

local function ends(bufnr, suffix)
  return vim.endswith(fname(bufnr), suffix)
end

local function matches(bufnr, pattern)
  return fname(bufnr):match(pattern) ~= nil
end

local function any_has(bufnr, substrs)
  for _, substr in ipairs(substrs) do
    if has(bufnr, substr) then
      return true
    end
  end

  return false
end

local function any_match(bufnr, patterns)
  for _, pattern in ipairs(patterns) do
    if matches(bufnr, pattern) then
      return true
    end
  end

  return false
end

vim.treesitter.query.add_predicate("is-rspec?", function(_, _, bufnr, _)
  return (
    ends(bufnr, "_spec.rb") or
    has(bufnr, "/spec/")
  )
end, { force = true })

vim.treesitter.query.add_predicate("is-rspec-or-cucumber?", function(_, _, bufnr, _)
  return (
    ends(bufnr, "_spec.rb") or
    has(bufnr, "/spec/") or
    has(bufnr, "/features/step_definitions/")
  )
end, { force = true })

vim.treesitter.query.add_predicate("is-ruby-request-spec?", function(_, _, bufnr, _)
  return any_has(bufnr, {
    "/spec/controllers/",
    "/spec/requests/",
  })
end, { force = true })

vim.treesitter.query.add_predicate("is-active-record?", function(_, _, bufnr, _)
  return has(bufnr, "/app/models/") and ends(bufnr, ".rb")
end, { force = true })

vim.treesitter.query.add_predicate("is-rails-app-ruby?", function(_, _, bufnr, _)
  return (
    (ends(bufnr, ".rb") and any_has(bufnr, {
      "/app/channels/",
      "/app/controllers/",
      "/app/helpers/",
      "/app/jobs/",
      "/app/mailers/",
      "/app/models/",
    })) or
    has(bufnr, "/app/views/")
  )
end, { force = true })

vim.treesitter.query.add_predicate("is-rails-model-observer?", function(_, _, bufnr, _)
  return matches(bufnr, "/app/models/.*_observer%.rb$")
end, { force = true })

vim.treesitter.query.add_predicate("is-rails-job?", function(_, _, bufnr, _)
  return matches(bufnr, "/app/jobs/.*%.rb$")
end, { force = true })

vim.treesitter.query.add_predicate("is-rails-helper-or-view?", function(_, _, bufnr, _)
  return matches(bufnr, "/app/helpers/.*_helper%.rb$") or has(bufnr, "/app/views/")
end, { force = true })

vim.treesitter.query.add_predicate("is-rails-controller?", function(_, _, bufnr, _)
  return matches(bufnr, "/app/controllers/.*%.rb$")
end, { force = true })

vim.treesitter.query.add_predicate("is-rails-controller-or-mailer?", function(_, _, bufnr, _)
  return any_match(bufnr, {
    "/app/controllers/.*%.rb$",
    "/app/mailers/.*%.rb$",
    "/app/models/.*_mailer%.rb$",
  })
end, { force = true })

vim.treesitter.query.add_predicate("is-rails-mailer?", function(_, _, bufnr, _)
  return any_match(bufnr, {
    "/app/mailers/.*%.rb$",
    "/app/models/.*_mailer%.rb$",
  })
end, { force = true })

vim.treesitter.query.add_predicate("is-rails-concern?", function(_, _, bufnr, _)
  return matches(bufnr, "/app/[^/]+/concerns/.*%.rb$")
end, { force = true })

vim.treesitter.query.add_predicate("is-rails-url-helper-context?", function(_, _, bufnr, _)
  return (
    (ends(bufnr, ".rb") and any_has(bufnr, { "/app/controllers/", "/app/helpers/", "/app/mailers/" })) or
    has(bufnr, "/app/views/") or
    any_match(bufnr, {
      "/test/controllers/.*_test%.rb$",
      "/test/integration/.*_test%.rb$",
      "/test/system/.*_test%.rb$",
      "/spec/features/.*_spec%.rb$",
      "/spec/requests/.*_spec%.rb$",
    })
  )
end, { force = true })

vim.treesitter.query.add_predicate("is-rails-migration?", function(_, _, bufnr, _)
  return has(bufnr, "/db/migrate/")
end, { force = true })

vim.treesitter.query.add_predicate("is-rails-schema?", function(_, _, bufnr, _)
  return has(bufnr, "/db/migrate/") or ends(bufnr, "/db/schema.rb")
end, { force = true })

vim.treesitter.query.add_predicate("is-ruby-rake?", function(_, _, bufnr, _)
  return (
    ends(bufnr, ".rake") or
    matches(bufnr, "/Rakefile[^/]*$")
  )
end, { force = true })

vim.treesitter.query.add_predicate("is-rails-routes?", function(_, _, bufnr, _)
  return matches(bufnr, "/config/routes.*%.rb$")
end, { force = true })

vim.treesitter.query.add_predicate("is-rails-test?", function(_, _, bufnr, _)
  return any_match(bufnr, {
    "/test/test_[^/]*%.rb$",
    "/test/.*/test_[^/]*%.rb$",
    "/test/.*_test%.rb$",
    "/features/step_definitions/.*%.rb$",
  })
end, { force = true })

vim.treesitter.query.add_predicate("is-rails-unit-test?", function(_, _, bufnr, _)
  return any_match(bufnr, {
    "/test/channels/.*_test%.rb$",
    "/test/controllers/.*_test%.rb$",
    "/test/helpers/.*_test%.rb$",
    "/test/integration/.*_test%.rb$",
    "/test/mailers/.*_test%.rb$",
    "/test/models/.*_test%.rb$",
    "/test/system/.*_test%.rb$",
  })
end, { force = true })

vim.treesitter.query.add_predicate("is-rails-controller-integration-system-test?", function(_, _, bufnr, _)
  return any_match(bufnr, {
    "/test/controllers/.*_test%.rb$",
    "/test/integration/.*_test%.rb$",
    "/test/system/.*_test%.rb$",
  })
end, { force = true })

vim.treesitter.query.add_predicate("is-rails-controller-helper-integration-system-test?", function(_, _, bufnr, _)
  return any_match(bufnr, {
    "/test/controllers/.*_test%.rb$",
    "/test/helpers/.*_test%.rb$",
    "/test/integration/.*_test%.rb$",
    "/test/system/.*_test%.rb$",
  })
end, { force = true })

vim.treesitter.query.add_predicate("is-rails-system-test?", function(_, _, bufnr, _)
  return matches(bufnr, "/test/system/.*_test%.rb$")
end, { force = true })

vim.treesitter.query.add_predicate("is-rails-request-test-context?", function(_, _, bufnr, _)
  return any_match(bufnr, {
    "/test/controllers/.*_test%.rb$",
    "/test/integration/.*_test%.rb$",
    "/spec/controllers/.*_spec%.rb$",
    "/spec/requests/.*_spec%.rb$",
  })
end, { force = true })

vim.treesitter.query.add_predicate("is-rails-system-test-or-feature-spec?", function(_, _, bufnr, _)
  return matches(bufnr, "/test/system/.*_test%.rb$") or matches(bufnr, "/spec/features/.*_spec%.rb$")
end, { force = true })

vim.treesitter.query.add_predicate("is-rspec-controller?", function(_, _, bufnr, _)
  return matches(bufnr, "/spec/controllers/.*_spec%.rb$")
end, { force = true })

vim.treesitter.query.add_predicate("is-rspec-helper?", function(_, _, bufnr, _)
  return matches(bufnr, "/spec/helpers/.*_spec%.rb$")
end, { force = true })

vim.treesitter.query.add_predicate("is-rspec-view?", function(_, _, bufnr, _)
  return matches(bufnr, "/spec/views/.*_spec%.rb$")
end, { force = true })

vim.treesitter.query.add_predicate("is-rails-spec-or-test?", function(_, _, bufnr, _)
  return has(bufnr, "/test/") or has(bufnr, "/spec/")
end, { force = true })
