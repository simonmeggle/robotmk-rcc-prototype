@echo off
REM This plugin gets executed 1x/h and checks the existence of a
REM rcc Python environment for Robotmk.
REM - Environment was not found:
REM  use bin/rcc.exe too create such an environment.
REM   - lib/hololib.zip exists: use this
REM   - lib/hololib.zip does not exist: use internet access
REM - Environment was found: 

SET AGENT_HOME=%PROGRAMDATA%\checkmk\agent
SET RCC=%AGENT_HOME%\bin\rcc.exe
SET ROBOCORP_HOME=%AGENT_HOME%\lib\robocorp
SET ENV_CONFIG_ROBOT=%AGENT_HOME%\config\robotmk-env\robot.yaml
SET ENV_CONFIG_CONDA=%AGENT_HOME%\config\robotmk-env\conda.yaml

REM === Create the environment
%RCC% run -r %ENV_CONFIG_ROBOT% --task robotmk-env --silent


echo %ERRORLEVEL%
REM # TODO: check for module import errors
