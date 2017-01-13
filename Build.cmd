@echo off

set BatchFile=%0
set Root=%~dp0
set BuildConfiguration=Debug
set MSBuildTarget=Build
set NodeReuse=true
set MSBuildAdditionalArguments=/m
set DeployVsixExtension=true

:ParseArguments
if "%1" == "" goto :DoneParsing
if /I "%1" == "/?" call :Usage && exit /b 1
if /I "%1" == "/debug" set BuildConfiguration=Debug&&shift&& goto :ParseArguments
if /I "%1" == "/release" set BuildConfiguration=Release&&shift&& goto :ParseArguments
if /I "%1" == "/clean" set MSBuildTarget=Clean&&shift&& goto :ParseArguments
if /I "%1" == "/build" set MSBuildTarget=Build&&shift&& goto :ParseArguments
if /I "%1" == "/rebuild" set MSBuildTarget=Rebuild&&shift&& goto :ParseArguments
if /I "%1" == "/restore" set MSBuildTarget=RestorePackages&&shift&& goto :ParseArguments
if /I "%1" == "/no-deploy-extension" set DeployVsixExtension=false&&shift&& goto :ParseArguments
call :Usage && exit /b 1
:DoneParsing


set BinariesDirectory=%Root%Binaries\%BuildConfiguration%\
set LogFile=%BinariesDirectory%Build.log
call :PrintColor Gray "Setting LogFile=%LogFile%"
call :PrintColor Gray "Setting BinariesDirectory=%Root%Binaries\%BuildConfiguration%\"
if not exist "%BinariesDirectory%" mkdir "%BinariesDirectory%" || goto :BuildFailed

REM Restore the NuGet packages
call "%Root%\Restore.cmd" || goto :BuildFailed

set DeveloperCommandPrompt=%VS150COMNTOOLS%\VsDevCmd.bat

REM Get Developer Command Prompt
if "%VisualStudioVersion%" == "" (
  call "%DeveloperCommandPrompt%" || goto :BuildFailed
)


msbuild /nologo /consoleloggerparameters:Verbosity=minimal /fileLogger /fileloggerparameters:LogFile="%LogFile%";verbosity=diagnostic /t:"%MSBuildTarget%" /p:Configuration="%BuildConfiguration%" /p:DeployVsixExtension="%DeployVsixExtension%" "%Root%Build\Build.proj" %MSBuildAdditionalArguments%
if ERRORLEVEL 1 (
    echo.
    call :PrintColor Red "Build failed, for full log see %LogFile%."
    exit /b 1
)

echo.
call :PrintColor Green "Build completed successfully, for full log see %LogFile%"
exit /b 0

:Usage
echo Usage: %BatchFile% [/rebuild^|/rebuild^|/restore^] [/debug^|/release] [/no-deploy-extension]
echo.
echo   Build targets:
echo     /clean                   Only clean the solution
echo     /build                   Only build the solution
echo     /rebuild                 Perform a clean, then build
echo     /restore                 Only restore NuGet packages
echo.
echo   Build options:
echo     /debug                   Perform debug build (default)
echo     /release                 Perform release build
echo     /no-deploy-extension     Does not deploy the VSIX extension when building the solution
echo.
goto :eof

:BuildFailed
call :PrintColor Red "Build failed with ERRORLEVEL %ERRORLEVEL%"
exit /b 1

:PrintColor
"%Windir%\System32\WindowsPowerShell\v1.0\Powershell.exe" write-host -foregroundcolor %1 "'%2'"
