setlocal
call "%VS140COMNTOOLS%vsvars32.bat"
echo "building %~dp0\build.target"
msbuild -verbosity:m %~dp0\build.target

