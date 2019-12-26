# <p style="text-align: center;" align="center">Cronux</p>

<p style="text-align: center;" align="center">Super useful handy, hacky and wacky commands to perform simple and complex task on the Windows command line</p>	

___

<span style="display:block;text-align:center"> ![Travis (.org)](https://img.shields.io/travis/Thecarisma/Cronux?style=flat)	![GitHub repo size](https://img.shields.io/github/repo-size/Thecarisma/Cronux)	![GitHub contributors](https://img.shields.io/github/contributors/Thecarisma/Cronux) [![Twitter Follow](https://img.shields.io/twitter/follow/iamthecarisma?style=social)](https://twitter.com/iamthecarisma)	 [![Support on Patreon](https://img.shields.io/static/v1?label=Support%20on%20Patreon&message=$5&color=brightgreen)](https://www.patreon.com/join/thecarisma/checkout?rid=3556842)</span>

This repo contains Super useful handy commands to perform simple and complex task on the Windows command line. Most Linux systems comes 
pre-installed with useful utilities and programs which makes working with the terminal easy, fun and provides easy api to execute 
various task. Windows even has more powerful command line functionality but requires journey to the abysses to use, windows 
provide powerful api through the visual basic script, powershell and the .NET sdk. 

Cronux simplify the use of the windows command line functionality by combining the use of visual basic script, powershell and .NET sdk 
to execute command to perform operations. It makes heavey use of meta-programming to achive some functionalities.

This script is most useful if you enjoy the power of linux and unix terminal or you switch between other OS and Windows often.

___

## Table of content
- [Prerequisite](#prerequisite)
- [Installation](#installation)
	- [Install](#install)
	- [Uninstall](#uninstall)
- [Usage](#usage)
- [Available Commands](#available-commands)
- [Drawbacks And Safety](#drawbacks-and-safety)
- [Contributing](#contributing)
- [Support](#support)
- [License](#license)

### Prerequisite

This command is exclusive to windows OS, so you need any version of Windows OS after Windows XP. Some of the command 
requires the app to be present but that only affect the commands. The app needed is the name of the sub folder in the commands 
folder.

### Installation

The script is completely independent as it relies on Windows OS api and infrastructure all the logic is native to the platform. 
To install the script just download from the [release](https://github.com/Thecarisma/Cronux/releases). 

#### Install

If you have git bash installed use the one line command below to install cronux 

```bash
git clone https://github.com/Thecarisma/Cronux.git && cd ./Cronux && ./Cronux.bat install prod
```

To use all the commands you will need to prefix the word **Cronux** before the command e.g `Cronux clear`, `Cronux sudo` e.t.c to make the 
command available independent of Cronux itself install the commands with

```
Cronux install
```

All the commands will be installed in the Program files folder `C:\Program Files\Cronux` and the folder will be added to path. The command 
can then be executed without prefixing **Cronux** e.g.

```
clear
elevate 
echocolor
...
```

If you want Cronux to be available in your system path use the command below to add the folder into the **PATH** variable.
You should only add Cronux directory to path if you did not install it. 

```bash
Cronux addtopath ./
```

The addpath converts path to absolute windows compatible short pathname.

#### Uninstall

To uninstall the Entrie Cronux and it sub commands Scripts use the command below

```
Cronux uninstall all
```

To remove a single command for example when an actual program with the same full functionality 
has been installed e.g the **ls** command which mimics  the windows **dir.exe** program
should be removed when the real program **ls.exe** is installed (e.g from the mingwn compiler toolchain). 

```
Cronux removecommand ls
```

### Usage

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

Note that custom advertisment, hint or quote is shown when command is run to silent the quote add the 
command `nb` to your command argument at any point

### Available Commands

To view the detail help message for each commands 

```bash
Cronux help [command]
```

or if Cronux is installed

```bash
chelp [command]
```

All the command are listed below with it alias(es)

```bash
clear, cls, ls, dir, elevate, sudo, su, wget, download, irs, uninstall, remove, removecommand, 
cinstall, install, rmlong, help, echocolor, colorlist, getenv, setenv, delenv, delenv, close, 
cat, printfile, ssay, say, testlabel, compilescript, cbackup, backup, chelp, addpath, setenvf, 
delpath, zip, archive, unzip, extract, listzip, showzip, qproc, qport, qid, p, $, ckubeget, 
gitlogp, ckubeddel, ckubedel, ckubedget, ckubeget, ckubelogs, ckubelogsf, createdircontext, 
createdirbgcontext, createfilecontext, createdesktopcontext, gen.

```

### Drawbacks And Safety

The commands are not full programs and might not behave as expected completely. Also the command that comes with Cronux 
should be remove after the actual program has been installed.

Most of the operation requires a lot of care as it can damage the system in some instance e.g such as the entire 
environment variable commands. Executing such command in Cronux will first backup sensitive and important files to it 
backup folder before executing the commands. If the command causes un foreseen damages the backed up files can be used to 
revert back to previous environment. Below are neccesary format for backups.

```bash
ROAMING_FOLDER=%HOMEDRIVE%%HOMEPATH%\AppData\Roaming\Cronux\
BACKUP_FOLDER=%HOMEDRIVE%%HOMEPATH%\AppData\Roaming\Cronux\backup\
BACKUP_ENVIRONMENT_FOLDER=%HOMEDRIVE%%HOMEPATH%\AppData\Roaming\Cronux\environment\
```
ROAMING_FOLDER: The Cronux roaming folder for backup, configuration and other datas.
BACKUP_FOLDER: This is the main folder where a file is backed up in the following format before deletion `!BACKUP_FOLDER!\!filename!!fileextension!.!time_stamp!`.cronux.backup
BACKUP_ENVIRONMENT_FOLDER: The environment variables is backed up in this folder before manipulating it.

### Contributing

Before you begin contribution please read the contribution guide at [CONTRIBUTING GUIDE](./CONTRIBUTING.MD)

If you have any issue or you just want more command to be added you can file a request [issue](https://github.com/Thecarisma/Cronux/issues/new) 
anytime and if you just add a more interesting, fun and usefull command do not hesitate to send a 
[pull request](https://github.com/Thecarisma/Cronux/compare) 

Please and please and please and please do not modify the *CronuxTestRunner.bat* Script if you do not understand how 
it works. *do not touch it. it freaking works*, but if you think the scripts should pass a test raise an issue for 
it before sending a PR for modified *CronuxTestRunner.bat*. if a PR modified *CronuxTestRunner.bat* without opening an 
issue first it is closed immediately. *don't freaking touch it if you don't understand it*.

May the force be with you.

## Support

You can support some of this community as they make big impact in the developement of people to get started with software engineering and open source.

- https://www.patreon.com/devcareer
- https://opencollective.com/osca

Or if you want to buy me a drink > https://patreon.com/thecarisma. Thanks!🤗

### License

The MIT License Copyright (c) 2019 Adewale Azeez Built with :heart:

