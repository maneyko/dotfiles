"""Define magic command to save session history to log file.

Links
-----
Startup Files
    https://ipython.readthedocs.io/en/stable/interactive/tutorial.html#startup-files

Defining Custom Magics
    https://ipython.readthedocs.io/en/stable/config/custommagics.html
"""

import os
import sys
import time
import atexit
import contextlib
from IPython import get_ipython
from IPython.core.magic import register_line_magic

ipython = get_ipython()

@contextlib.contextmanager
def suppress_stdout():
    with open(os.devnull, 'w') as devnull:
        old_stdout = sys.stdout
        sys.stdout = devnull
        try:
            yield
        finally:
            sys.stdout = old_stdout

@register_line_magic
def saveall(line, exit=False):
    'Saves entire history of session to log file.'
    HOME = os.environ['HOME']
    log_path = os.path.join(HOME, '.ipython/profile_maneyko/logs')
    if not os.path.isdir(log_path):
        os.makedirs(log_path)
    if exit:
        dec = 1
    else:  # Don't include magic command in log
        dec = 2
    hist_size = ipython.run_cell('len(In)').result - dec
    timestamp = time.strftime('%Y-%m-%d_@_%H:%M:%S')
    filepath = os.path.join(log_path, timestamp)
    filename = '{}.py'.format(filepath)
    with suppress_stdout():
        ipython.magic('save {} 1-{:d}'.format(filename, hist_size))

atexit.register(saveall, line=None, exit=True)

