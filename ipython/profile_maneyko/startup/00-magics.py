"""
Define magic command to save session history to log file.

.. https://ipython.readthedocs.io/en/stable/interactive/tutorial.html#startup-files
.. https://ipython.readthedocs.io/en/stable/config/custommagics.html
"""

import os
import sys
import time as _time
import atexit

from IPython import get_ipython
from IPython.core.magic import register_line_magic

script_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.append("%s/../../maneyko" % script_dir)
from maneyko import *

HOME = os.environ['HOME']
ipython = get_ipython()

@register_line_magic
def saveall(line, exit=False):
    """Saves entire history of session to log file."""
    import sys
    if (sys.version_info[0] == 3 and sys.version_info[1] >= 9) or sys.version_info[0] > 3:
        return
    logs = os.path.join(HOME, '.ipython/profile_maneyko/logs')
    ninputs = ipython.run_cell('len(In)').result or 0
    if not os.path.isdir(logs):
        os.makedirs(logs)
    if exit == True:
        history =  ninputs - 1
    else:  # Don't include magic command in log
        history =  ninputs - 2
    timestamp = _time.strftime('%Y-%m-%d_@_%H:%M:%S')
    logfile = os.path.join(logs, timestamp) + '.py'
    with suppress_stdout():
        ipython.magic('save {} 1-{:d}'.format(logfile, history))

atexit.register(saveall, line=None, exit=True)
