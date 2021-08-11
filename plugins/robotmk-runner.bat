@echo off
REM This wrapper gets executed in a predefined EXECUTION INTERVAL.
REM It checks the existence of a rcc Python environment for Robotmk,
REM defined in config/robotmk-env.
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

REM Hash the conda.yaml and check if an env with the hash name exists.
REM In order to be a short-runner, exit immediately if env not present!
REM --- 
REM Remark from Jippo: Please note, rcc env ... commands are old way of doing things. And rcc env hash does not match hashing used in rcc holotree ... set of commands.
FOR /F "tokens=5" %%a in ('rcc.exe env hash %ENV_CONFIG_CONDA% 2^>^&1') do SET OUT=%%a
SET HASH=%OUT:~0,-1%

IF EXIST %ROBOCORP_HOME%\live\%HASH% (
    REM Robotmk environment exists
    REM Runner reads robotmk.yml and starts each suite within an rcc environment.
    %RCC% run -r %ENV_CONFIG_ROBOT% --task robotmk-runner
    REM %RCC% run -r %ENV_CONFIG_ROBOT% --task robotmk-runner --silent
) ELSE (
    echo NOTE: Environment %HASH% not found. 
)
