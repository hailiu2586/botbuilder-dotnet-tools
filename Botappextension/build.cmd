call python setup.py bdist_wheel
call az extension remove -n botappextension
call az extension add --source dist\botappextension-0.0.2-py2.py3-none-any.whl
