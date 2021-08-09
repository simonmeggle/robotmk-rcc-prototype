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
SET ROBOTMK_ENV_LIB=%AGENT_HOME%\lib\robotmk-env
SET ROBOTMK_ENV_CONFIG=%AGENT_HOME%\config\robotmk-env\robot.yaml


echo ---ROBOTMK---
echo foo

REM TODO: check if env is present: 
REM rcc env hash .\config\robotmk-env\conda.yaml => is hash an env in lib/robocorp/live? 

REM === Create the environment
REM # TODO: Make this silent
%RCC% run -r %ROBOTMK_ENV_CONFIG% >NUL
echo %ERRORLEVEL%
REM # TODO: check for error
