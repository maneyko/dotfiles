"""
Personal module for frequently used tools.

Include in PYTHONPATH::

    export PYTHONPATH="$HOME/.ipython/maneyko:$PYTHONPATH"

Example
-------
>>> from maneyko import sh
>>> sh('echo Hello world')
"""

import os
import sys
import contextlib
import subprocess

def sh(cmd):
    """Executes a shell command synchronously."""
    proc = subprocess.Popen([cmd], shell=True, stdout=subprocess.PIPE)
    out, err = proc.communicate()
    return out.decode('utf-8').strip()

@contextlib.contextmanager
def suppress_stdout():
    """Suppress stdout when exeuting command.

    Example
    -------
    >>> with suppress_stdout():
    >>>     print('Hello world')
    """
    with open(os.devnull, 'w') as devnull:
        old_stdout = sys.stdout
        sys.stdout = devnull
        try:
            yield
        finally:
            sys.stdout = old_stdout
