
# http://ipython.readthedocs.io/en/stable/config/options/terminal.html
c = get_config()  # From who?

c.TerminalInteractiveShell.confirm_exit = False

c.BaseIPythonApplication.profile = 'maneyko'
c.InteractiveShell.colors = 'Linux'
