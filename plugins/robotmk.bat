@echo on
REM This wrapper gets executed in the REGULAR Checkmk check interval. 
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
FOR /F "tokens=5" %%a in ('rcc.exe env hash %ENV_CONFIG_CONDA% 2^>^&1') do SET OUT=%%a
SET HASH=%OUT:~0,-1%

IF EXIST %ROBOCORP_HOME%\live\%HASH% (
    REM Robotmk environment exists
    %RCC% run -r %ENV_CONFIG_ROBOT% --task robotmk 
    REM %RCC% run -r %ENV_CONFIG_ROBOT% --task robotmk --silent
) ELSE (
    echo NOTE: Environment %HASH% not found. 
)