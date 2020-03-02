# <p style="text-align: center;" align="center">Cronux</p>

<p style="text-align: center;" align="center">Super useful handy, hacky and wacky commands to perform simple and complex task on the command line</p>	

___

<span style="display:block;text-align:center"> ![Travis (.org)](https://img.shields.io/travis/Thecarisma/Cronux?style=flat)	![GitHub repo size](https://img.shields.io/github/repo-size/Thecarisma/Cronux)	![GitHub contributors](https://img.shields.io/github/contributors/Thecarisma/Cronux) [![Twitter Follow](https://img.shields.io/twitter/follow/iamthecarisma?style=social)](https://twitter.com/iamthecarisma)	 [![Support on Patreon](https://img.shields.io/static/v1?label=Support%20Devcareer%20on%20Patreon&message=$10&color=brightgreen)](https://www.patreon.com/join/devcareer/checkout?rid=3922862)</span>

This repo contains Super useful handy commands to perform simple and complex task on the command line. Powershell has powerful command line functionality due to it interopability with visual basic script, the .NET sdk and installed apps. 

Most powershell only commands are wrapped into batch and bash to make them available on windows command prompt and linux shell. This script is most useful if you enjoy the power of linux and unix terminal or you switch between other OSes and Windows often.

Do not heisitate to send in a PR with your awesome powershell script.

___

## Table of content
- [Requirements](#requirements)
- [Installation](#installation)
	- [Install](#install)
		- [Powershell](#powershell)
		- [Chocolatey](#chocolatey)
		- [Git Bash](#git-bash)
		- [Download Zip and Extract](#download-zip-and-extract)
	- [Uninstall](#uninstall)
- [Usage](#usage)
	- [Powershell Exeception](#powershell-exeception)
- [Available Commands](#available-commands)
- [Contributing](#contributing)
- [Support](#support)
- [Useful Links](#useful-links)
- [License](#license)

## Requirements

- Powershell 2+
- Windows Command Prompt on Microsoft Windows
- Any shell on Linux and unix

## Installation

The script provides wrapper commands for various application e.g git, kubectl. The main requirement for Cronux is powershell 3 and above.

### Install

#### Powershell

Run your powershell as admin and execute:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://thecarisma.github.io/installx.ps1'))
```

#### Chocolatey

#### Git Bash

If you have git bash installed use the one line command below to install cronux 

```bash
git clone https://github.com/Thecarisma/Cronux.git && cd ./Cronux && ./Cronux.bat install
```

#### Download Zip and Extract

Download the zip archive from the repo or release page, extract it to any folder on your disk and execute Cronux from within the folder.

To use all the commands you will need to prefix the word **Cronux** before the command e.g `Cronux clear`, `Cronux sudo` e.t.c to make the command available independent of Cronux itself install Cronux with:

```
Cronux.bat install
```

### Uninstall

To uninstall the Entrie Cronux and it sub commands Scripts use the command below

```
Cronux uninstall
```

To remove a single command for example when an actual program with the same full functionality 
has been installed e.g the **ls** command which mimics  the windows **dir.exe** program
should be removed when the real program **ls.exe** is installed (e.g from the mingwn compiler toolchain). 

```
Cronux removecommand ls
```

## Usage

After installation you can use the commands independently as each batch script 
will be generated for each command. Note that not all the command will have it 
own script such as the **dir** command as it will conflict with the installed dir program 
that comes pre-installed with windows.

E.g to open notepad as administrator

```bash
elevate notepad
```

If you do not choose to install Cronux.bat use below to execute commands from any folder. 
To use, extract Cronux.bat to a folder of your choice, a sample use to open cmd as administrator

```bash
Cronux elevate cmd
```

### Powershell Exeception

If you try to execute the commands from powershell you will have to set the Execution Policy to Bypass else you should call the .bat command directly e.g instead of `gitpush` use `gitpush.bat`. Top allow the scripts to execute natively change the execution policy for your powershell to bypass:

```powershell
Set-ExecutionPolicy Bypass
```

or use the command in Cronux:

```powershell
makepsunsafe.bat
```

After you are done with the session or when you want the Execution policy to be secure again execute

```powershell
Set-ExecutionPolicy Restricted
```

or use the command in Cronux:

```powershell
makepssafeagain.bat
```

It advisable to make the Execution policy restricted for safety reasons.

## Available Commands

All the command are listed below with it alias(es)

```bash
gitclone, gitfpush, gitpull, gitpush, $, aboutx, base64, base64s,
batforps, buildcronux, chelp, close, Cronux, extractx, gencert,
gencodesigncert, installpfx, installpfxx, installx, listx, printhead,
pstobat, wrapcommand, Bye.
```

To view all the Cronux native and exported commands:

```shell
listx -All
```

To view the detail help message for a command:

```bash
Cronux chelp [command]
#or
[command] help

#e.g. base64 help
```

## Contributing

Before you begin contribution please read the contribution guide at [CONTRIBUTING GUIDE](./CONTRIBUTING.MD)

If you have any issue or you just want more command to be added you can file a request [issue](https://github.com/Thecarisma/Cronux/issues/new) 
anytime and if you just add a more interesting, fun and usefull command do not hesitate to send a 
[pull request](https://github.com/Thecarisma/Cronux/compare) 

Please and please and please and please do not modify the *CronuxTestRunner.ps1* Script if you do not understand how it works. *do not touch it. it freaking works*, but if you think the scripts should pass a test raise an issue for it before sending a PR for modified *CronuxTestRunner.bat*. if a PR modified *CronuxTestRunner.ps1* without opening an 
issue first the PR will closed. *don't freaking touch it if you don't understand it*.

May the force be with you.

## Support

You can support some of this community as they make big impact in the developement of people to get started with software engineering.

- https://www.patreon.com/devcareer

## Useful Links

 - [Powershell](https://docs.microsoft.com/en-us/powershell/scripting/overview)
 - [.NET Documentation](https://docs.microsoft.com/en-us/dotnet/)
 - [cmd.exe](https://en.wikipedia.org/wiki/Cmd.exe)
 - [Unix Shell](https://en.wikipedia.org/wiki/Unix_shell)

## License

The MIT License Copyright (c) 2019 Adewale Azeez

