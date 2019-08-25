# <p style="text-align: center;" align="center">Cronux</p>

<p style="text-align: center;" align="center">Super useful handy commands to perform simple and complex task on the Windows command line</p>

___

This script bring the power of the Linux and Unix terminal to the Windows terminal and command line. Most Linux systems comes 
pre-installed with useful utilities and programs which makes working with the terminal easy, fun and provides easy api to execute 
various task. Windows even has more powerful command line functionality but requires journey to the abysses to use, windows 
provide powerful api through the visual basic script, powershell and the .NET sdk. 

Cronux simplify the use of the windows command line functionality by combining the use of visual basic script, powershell and .NET sdk 
to execute Linux like command such as curl, grep e.t.c 

This script is most useful if you enjoy the power of linux and unix terminal or you switch between other OS and Windows often.

___

## Table of content
- [Installation](#installation)
	- [Install](#install)
	- [Uninstall](#uninstall)
- [Usage](#usage)
- [Available Commands](#available-commands)
- [Drawbacks And Safety](#drawbacks-and-safety)
- [Contributing](#contributing)
- [License](#license)

### Installation

The script is completely independent as it relies on Windows OS api and infrastructure all the logic is native to the platform. 
To install the script just download from the [release](https://github.com/Thecarisma/Cronux/releases). 

#### Install

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
You should only add Cronux directory to path is you did not install it. 

```bash
Cronux addtopath C:/the/full/path/to/where/cronux.bat/is/
```

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
command `noad` to your command argument at any point

### Available Commands

```bash
clear, cls, ls, dir, elevate, sudo, su, wget, download, irs, uninstall, remove, removecommand
noadmin-install, install, rmlong, help, echocolor, colorlist, getenv, setenv, delenv
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
BACKUP_FOLDER: This is the main folder where a file is backed up in the following format before deletion `!BACKUP_FOLDER!\!filename!!fileextension!.!time_stamp!`.
BACKUP_ENVIRONMENT_FOLDER: The environment variables is backed up in this folder before manipulating it.

### Contributing

If you have any issue or you just want more command to be added you can file a request [issue](https://github.com/Thecarisma/Cronux/issues/new) 
anytime and if you just add a more interesting, fun and usefull command do not hesitate to send a 
[pull request](https://github.com/Thecarisma/Cronux/compare) 

### License

GNU Lesser General Public License v3.0 Copyright (c) 2019 Azeez Adewale Built with :heart:

