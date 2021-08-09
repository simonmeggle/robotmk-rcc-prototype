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

### I) A dedicated rcc Python environment for Robotmk

**Requirement**: Robotmk should run within its own environment which brings all modules (mergedeep, dateutil, etc).

#### I.1) Quick win: Without holotree


`plugins/3600/robotmk_env.bat`

Ausführung 1x/h
schnelle Prüfung, ob robotmk-env existiert
falls nicht: 

	<<<robotmk>>>
	Robotmk Python environment in preparation...
	
    bin/rcc.exe

#### I.2) The hard way: using holotree

The newest version of rcc has a concept called **holotree** which is used for [https://github.com/robocorp/rcc/blob/master/docs/environment-caching.md](environment caching). With this technology it should be possible that robotmk can be run without downloading any files on the machine. 


### II) Dedicated rcc Python environments for each test 

**Requirement**: Robotmk (run within its own rcc environment) executes Robot tests again with `rcc` and an own isolated environment. There should be no version conflict of Python modules at all. 

#### I.1) Quick win: Without holotree


#### I.2) The hard way: using holotree


