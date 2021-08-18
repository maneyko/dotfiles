
# http://ipython.readthedocs.io/en/stable/config/options/terminal.html

# from traitlets.config import Config
# c = Config()

c = get_config()  # From who?

c.TerminalInteractiveShell.confirm_exit = False

c.BaseIPythonApplication.profile = 'maneyko'
c.InteractiveShell.colors = 'Linux'

c.IPCompleter.use_jedi = False
