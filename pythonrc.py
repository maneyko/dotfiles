from pprint import pp
import sys


def add_py_repl_bindings():
    from _pyrepl.simple_interact import _get_reader
    reader = _get_reader()
    bindings = {
        "backward-word": [
            r"\e[1;3D",
            r"\e\e[D",
            # r"\M-\[1;3D",
        ],
        "forward-word": [
            r"\e[1;3C",
            r"\e\e[C",
            # r"\M-\[1;3C",
        ]
    }

    for command, sequences in bindings.items():
        for sequence in sequences:
            reader.bind(sequence, command)


if sys.version_info >= (3, 13):
    add_py_repl_bindings()
