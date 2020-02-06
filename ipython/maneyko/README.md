# maneyko pip Package

Set of tools I use that make programming in Python easier and faster

## Example

The `sh` command comes in handy:

```python
from maneyko import sh

sh('echo Hello world!')
'Hello world'

sh("ps ax | grep -i python | awk '{print $5}'").splitlines()
['/usr/local/Cellar/python/3.7.6_1/Frameworks/Python.framework/Versions/3.7/Resources/Python.app/Contents/MacOS/Python',
 '/bin/sh',
 'grep']
```
