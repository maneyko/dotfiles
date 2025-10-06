
# http://ipython.readthedocs.io/en/stable/config/options/terminal.html

# from traitlets.config import Config
# c = Config()

c = get_config()  # From who?

c.TerminalInteractiveShell.confirm_exit = False

c.BaseIPythonApplication.profile = 'maneyko'
c.InteractiveShell.colors = 'Linux'

# Make pandas vertical display show all columns
# pd.set_option('display.max_rows', None)

c.IPCompleter.use_jedi = False
