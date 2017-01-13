@echo off

set msbuild="C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\MSBuild.exe"

%msbuild% /t:Pack Ollon.VisualStudio.ProjectSystem.Tasks.csproj

pause
