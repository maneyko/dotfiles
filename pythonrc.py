import sys

def add_py_repl_bindings():
    from _pyrepl.simple_interact import _get_reader
    reader = _get_reader()

    bindings = (
        (r"\e[1;3D", "backward-word"),
        (r"\e[1;3C", "forward-word"),
        (r"\e\e[D",  "backward-word"),
        (r"\e\e[C",  "forward-word"),
    )
    for sequence, command in bindings:
        reader.bind(sequence, command)

if sys.version_info >= (3, 13):
    add_py_repl_bindings()
