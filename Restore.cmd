@echo off

set RepositoryRoot=%~dp0
set DevDivPackages=%RepositoryRoot%src\Setup\DevDivPackages

:ParseArguments
if /I "%1" == "/?" goto :Usage
if /I "%1" == "/clean" set RestoreClean=true&&shift&& goto :ParseArguments
if /I "%1" == "/fast" set RestoreFast=true&&shift&& goto :ParseArguments
goto :DoneParsing

:DoneParsing

REM Allow for alternate solutions to be passed as restore targets.
set Solution=%1
if "%Solution%" == "" set Solution=%RepositoryRoot%\MSBuild.Tasks.sln

REM Load in the inforation for NuGet
call "%RepositoryRoot%build\scripts\LoadNuGetInfo.cmd" || goto :LoadNuGetInfoFailed

if "%RestoreClean%" == "true" (
    echo Clearing the NuGet caches
    call "%NugetExe%" locals all -clear || goto :CleanFailed
)

if "%RestoreFast%" == "" (
    echo Deleting project.lock.json files
    pushd "%RepositoryRoot%src"
    echo "Dummy lock file to avoid error when there is no project.lock.json file" > project.lock.json
    del /s /q project.lock.json > nul
    popd
)

echo Restoring packages: Tools
call "%NugetExe%" restore "%RepositoryRoot%build\Targets\Solution.Project.json" %NuGetAdditionalCommandLineArgs% || goto :RestoreFailed

echo Locating MSBuild for Solution restore
call "%RepositoryRoot%SetDevCommandPrompt.cmd" || goto :RestoreFailed

REM If we have an applocal copy of MSBuild, pass it to NuGet.  Otherwise, assume NuGet knows how to find it.
if exist "%DevenvDir%\..\..\MSBuild\15.0\Bin\MSBuild.exe" (
    set NuGetAdditionalCommandLineArgs=%NuGetAdditionalCommandLineArgs% -msbuildpath "%DevenvDir%\..\..\MSBuild\15.0\Bin"
)

echo Restoring packages: MSBuild.Tasks (this may take some time)
call "%NugetExe%" restore "%Solution%" %NuGetAdditionalCommandLineArgs% || goto :RestoreFailed



exit /b 0

:CleanFailed
echo Clean failed with ERRORLEVEL %ERRORLEVEL%
exit /b 1

:RestoreFailed
echo Restore failed with ERRORLEVEL %ERRORLEVEL%
exit /b 1

:LoadNuGetInfoFailed
echo Error loading NuGet.exe information %ERRORLEVEL%
exit /b 1

:Usage
@echo Usage: Restore.cmd /clean [Solution File]
exit /b 1

:PrintColor
"%Windir%\System32\WindowsPowerShell\v1.0\Powershell.exe" write-host -foregroundcolor %1 "'%2'"
