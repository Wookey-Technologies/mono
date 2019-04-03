setlocal
call "%VS140COMNTOOLS%vsvars32.bat"
echo "building %~dp0\build.target"
msbuild %~dp0\build.target

