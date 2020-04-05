
![](https://github.com/Thecarisma/Cronux/raw/master/docs/cronux.png)

# Cronux

Handy commands to perform simple and complex tasks with Powershell

___

![GitHub repo size](https://img.shields.io/github/repo-size/Thecarisma/Cronux)	![GitHub contributors](https://img.shields.io/github/contributors/Thecarisma/Cronux) [![Twitter Follow](https://img.shields.io/twitter/follow/iamthecarisma?style=social)](https://twitter.com/iamthecarisma)	 [![Support on Patreon](https://img.shields.io/static/v1?label=Support%20Devcareer%20on%20Patreon&message=$10&color=brightgreen)](https://www.patreon.com/join/devcareer/checkout?rid=3922862)

This repo contains Super useful handy commands to perform simple and complex task on the command line. Powershell has powerful command line functionality due to it interopability with visual basic script, the .NET sdk and installed apps. This project also exports over 100 built in commands in powershell to be used from the Windows Command prompt.

Most powershell only commands are wrapped into batch and bash to make them available on windows command prompt and linux shell. This script is most useful if you enjoy the power of linux and unix terminal or you switch between other OSes and Windows often.

Do not heisitate to send in a PR with your awesome powershell script.

___

## Table of content
- [Requirements](#requirements)
- [Installation](#installation)
	- [Install](#install)
		- [Powershell](#powershell)
		- [Git Bash](#git-bash)
		- [Download Zip and Extract](#download-zip-and-extract)
	- [Uninstall](#uninstall)
	- [Update](#update)
- [Creating alias](#creating-alias)
- [Usage](#usage)
	- [Powershell Exeception](#powershell-exeception)
- [Available Commands](#available-commands)
- [Wiki](#wiki)
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

#### Git Bash

If you have git bash installed use the one line command below to install cronux 

```bash
git clone https://github.com/Thecarisma/Cronux.git && cd ./Cronux && ./Cronux.sh installx
```

#### Download Zip and Extract

Download the zip archive from the repo or release page, extract it to any folder on your disk and execute Cronux from within the folder.

To use all the commands you will need to prefix the word **Cronux** before the command e.g `Cronux clear`, `Cronux sudo` e.t.c to make the command available independent of Cronux itself install Cronux with:

```
Cronux.bat installx
```

### Uninstall

To uninstall the Entrie Cronux and it sub commands Scripts use the command below

```
Cronux uninstallx
```

To remove a single command for example when an actual program with the same full functionality 
has been installed e.g the **ls** command which mimics  the windows **dir.exe** program
should be removed when the real program **ls.exe** is installed (e.g from the mingwn compiler toolchain). 

```
Cronux removecommand ls
```

### Update

If you already have Cronux installed you can execute the `updatex` command to update to the latest version.

```powershell
updatex
```

or 

```powershell
Cronux updatex
```

## Creating alias

The `shorty` command can be used to create a short alias for a long command. So instead of executing 
a long command from the CLI the alias script can be called to execute the commands e.g. the following 
command add edited stage files then commit it with the message 'new feature'. 

```powershell
git add .
git commit -m "new feature"
```

The shorty command can create a script to do the above operation without the need to type out all the 
git command. To create a short script for the command above just call `shorty` and add the command when 
prompt. On prompt AliasName enter the name for your generated script. On the Command prompt enter the commands 
if you are done youe .exit for the command value.

```powershell
shorty
#AliasName: gc
#Command: git add .
#Command: git commit -m "new feature"
#Command: .exit
```

You command will be generated in the folder **$ProgramData/CronuxShorty/**. Then you can just call the script 
`gc` in your terminal instead of typing the git command.

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
$, gencert, gencodesigncert, installpfx, installpfxx, batforps,
pstobat, wrapcommand, aboutx, buildcronux, chelp, helpx, installfolderx,
installx, listx, uninstallx, updatex, versionx, base64, base64s,
docronux, ps12markdown, psdoc, psdoc2markdown, extractx, superwatcher,
touch, watcher, watcherb, gitclone, gitcommit, gitfpush, gitpull,
gitpush, gitstatus, deletepod, getpods, kubecontext, logpod, podexec,
podshell, portforward, ipof, printhead, close, elevate, makepssafeagain,
makepsunsafe, whatami, Cronux
```

To view all the Cronux native and exported commands:

```shell
listx -All
```

To view the detail help message for a command:

```bash
Cronux helpx [command]
#or
[command] help

#e.g. base64 help
```

## Wiki

The wiki and documentation website are auto generated by Travis for every push.

- [commands](https://github.com/Thecarisma/Cronux/wiki/commands)
- [kubectl](https://github.com/Thecarisma/Cronux/wiki/kubectl)
- [documentation](https://github.com/Thecarisma/Cronux/wiki/documentation)
- [filefolder](https://github.com/Thecarisma/Cronux/wiki/filefolder)
- [cronux](https://github.com/Thecarisma/Cronux/wiki/Cronux)
- [archive](https://github.com/Thecarisma/Cronux/wiki/archive)
- [alias](https://github.com/Thecarisma/Cronux/wiki/alias)
- [crypto](https://github.com/Thecarisma/Cronux/wiki/crypto)
- [system](https://github.com/Thecarisma/Cronux/wiki/system)
- [git](https://github.com/Thecarisma/Cronux/wiki/git)
- [net](https://github.com/Thecarisma/Cronux/wiki/net)
- [certificates](https://github.com/Thecarisma/Cronux/wiki/certificates)
- [others](https://github.com/Thecarisma/Cronux/wiki/others)
- [conversions](https://github.com/Thecarisma/Cronux/wiki/conversions)

## Contributing

If you have any issue or you just want more command to be added you can file a request [issue](https://github.com/Thecarisma/Cronux/issues/new) 
anytime and if you just add a more interesting, fun and usefull command do not hesitate to send a 
[pull request](https://github.com/Thecarisma/Cronux/compare) 

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

