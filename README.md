# robotmk-rcc-prototype
A repository to test around with checkmk, robot framework, rcc and robotmk


## Introduction

At the current development state, [Robotmk](www.robotmk.org) requires a complete preinstalled Python environemnt, including all modules for Robot Framework, its libraries and helper modules. 

The purpose of this repository is to show how this process can be optimized by introducing the `rcc` client from [Robocorp](https://github.com/robocorp).

What rcc does is, briefly explained, to describe how a complete Python runtime environment for a Robot Framework automation looks like. With rcc, there should be no need to automate anything else which should be done on a pristine operating system in order to run robot tests. 

The original idea comes form this issue: https://github.com/simonmeggle/robotmk/issues/148

## Requirements

* Windows Operating System
* Checkmk Agent installed (v1.6/2)
* Git for Windows


## Using/Cloning this repository

This repository is meant to be cloned into the Checkmk agewnt directory on a Windows operating system. 
Because of the fact that this repository _adds_ files to the *existing* agent directory, cloning directly into the agent directory does not work (cloning requires an empty dir). Instead this is necessary: 

```
vagrant@win10rmk MINGW64 /c
$ cd ProgramData/checkmk/agent/

git init .
git remote add origin git@github.com:simonmeggle/robotmk-rcc-prototype.git
git fetch
git reset origin/main  # Required when the versioned files existed in path before "git init" of this repo.
git checkout main
```

Now the agent directory should have the following files: 

* `bin/rcc.exe`
* `config/robotmk.yml`
* `plugins.robotmk.py`
* `plugins.robotmk-runner.py`


## Goals

### I) A dedicated rcc Python environment for Robotmk/Robotmk-runner

**Requirement**: Robotmk should run within its own environment which brings all modules (mergedeep, dateutil, etc).

#### I.1) Quick win: Without holotree

* `robotmk_env.bat`: Environment creation for Robotmk
* `robotmk.bat`: "The" cmk plugin. Returns data to the agent. 

`robotmk_env.bat` gets executed hourly. It reads the definition from `\config\robotmk-env\robot.yaml` and starts the task `robotmk-env`. 

This task is only dummy Python file; the main purpose is to create an environment with all modules listed in conda.yml.

`robotmk.bat` is just a wrapper for `robotmk.py`. It gets executed in the regular check interval of the agent. It calculates the hash from `conda.yml` to determine if the Robotmk env is already created. If not, it exits. 

If the env is present, it starts the task `robotmk`, which is the normal controller execution of robotmk. 

*TODO*: How can `robotmk.bat` check if the environment creation is finished? When the creation is in process, the tast run of robotmk stucks.

#### I.2) The hard way: using holotree

The newest version of rcc has a concept called **holotree** which is used for [https://github.com/robocorp/rcc/blob/master/docs/environment-caching.md](environment caching). With this technology it should be possible that robotmk can be run without downloading any files on the machine. 


### II) Dedicated rcc Python environments for each test 

**Requirement**: `robotmk-runner.py` (run within Robotmk environment as task `robotmk-runner`) executes Robot tests again with `rcc` and an own isolated environment. There should be no version conflict of Python modules at all. 

#### I.1) Quick win: Without holotree

* `robotmk-runner.py` has to know the PATH where `rcc.exe` can be found
* iterate through all defined suites in `robotmk.yml`
* for each suite, execute `rcc -r path_to_robot_yml --task robotmk`
* all Arguments to the RF execution should be given to rcc after the double dash (see [how to pass arguments to robot from cli](https://github.com/robocorp/rcc/blob/master/docs/recipes.md#how-pass-arguments-to-robot-from-cli))

##### Step1: Pass Robot Framework arguments to tasks

`simpletest/robot.yml` with two tasks: 

```
tasks:
  # (1) manual execution 
  robotmk-man:
    shell: python -m robot --report NONE --outputdir output tasks.robot
  # (2) Omitting the robot file at the end expects the rest of arguments on the cmdline after `--` 
  robotmk:
    shell: python -m robot --report NONE --outputdir output 
```

(1) Execution of `robotmk-man` (without arguments) prints out the vars from the robot file:

```
cd robot/simpletest/
rcc run --task robotmk-man
...
...
==============================================================================
Tasks :: Template robot main suite.
==============================================================================
Minimal task                                                          "
VAR1=Value of var1 from script!
VAR2=Value of var2 from script!
| PASS |
``` 

(2) Goal: pass arguments to the `robotmk` task to pass variables/arguments:

```
rcc run --task robotmk -- --variable "VAR1:I AM VALUE1 FROM CMDLINE!" --variable "VAR2:Mee too..." tasks.robot
...
...
==============================================================================
Tasks :: Template robot main suite.
==============================================================================
Minimal task                                                          "
VAR1=I AM VALUE1 FROM CMDLINE!
VAR2=Mee too...
| PASS |
```

=> In this way, `robotmk-runner.py` will be able to start the Robot and hand over all parameters set in WATO.


##### Step2: needs adaption to robotmk.yml format and `robotmk.py`. 

#### I.2) The hard way: using holotree


### III) Execute Ansible hooks

**Requirement**: Before and after the `robotmk` task within a Robot, execute an Ansible task to configure the machine. 

TODO: pip installation of Ansible? 