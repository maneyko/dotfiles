"""
Personal module for frequently used tools.

Include in PYTHONPATH::

    export PYTHONPATH="$HOME/.ipython/maneyko:$PYTHONPATH"

Example
-------
>>> from maneyko import sh
>>> sh('echo Hello world')
'Hello world'
"""

import os
import re
import sys
import time
import contextlib
import subprocess


def sh(cmd):
    """Execute a shell command synchronously.

    Example
    -------
    >>> from maneyko import sh
    >>> sh('echo Hello world')
    'Hello world'
    """
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

class Timer:
    """Timer contextmanager

    Example
    -------
    >>> with Timer() as t:
    >>>     print('Hello world')
    >>> t.interval
    2.6000000000081513e-05
    """
    def __enter__(self):
        self.start = time.clock()
        return self

    def __exit__(self, *args):
        self.end = time.clock()
        self.interval = self.end - self.start


def backup_path(filepath):
    """
    Add a number before the file extension if the file already exists.

    Example
    -------
    >>> os.listdir('.')
    ['myfile.py']
    >>> backup_path('myfile.py')
    'myfile.1.py'
    >>> open('myfile.1.py', 'w').close()  # Create an empty file
    >>> backup_path('myfile.py')
    'myfile.2.py'
    """
    if not os.path.exists(filepath):
        return filepath
    pat = '(.[0-9]+)?.([A-Za-z]+$)'
    m = re.search(pat, filepath)
    number, extension = m.group(1, 2)
    if number is None:
        number = '.0'
    n = int(number[1:])
    name = re.sub(pat, r'.{}.\2'.format(n+1), filepath)
    if os.path.exists(name):
        return backup_path(name)
    return name
