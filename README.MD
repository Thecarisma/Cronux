# <p style="text-align: center;" align="center">Cronux</p>

<p style="text-align: center;" align="center">Bringing the linux and unix commands to the Windows platform</p>

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
- [Usage](#usage)
- [Available Commands](#available-commands)
- [Drawbacks](#drawbacks)
- [Contributing](#contributing)
- [License](#license)

### Installation

The script is completely independent as it relies on Windows OS api and infrastructure all the logic is native to the platform. 
To install the script just download from the [release](https://github.com/Thecarisma/Cronux/releases). 

To use all the commands you will need to prefix the word **Cronux** before the command e.g `Cronux clear`, `Cronux sudo` e.t.c to make the 
command available independent of Cronux itself install the commands 

```
Cronux install
```

All the commands will be installed in the Program files folder `C:\Program Files\Cronux` and the folder will be added to path. The command 
can then be executed without prefixing **Cronux** e.g.

```
clear
sudo 
ls
...
```

### Usage

if you do not choose to install Cronux.bat use below to execute commands from any folder. 
To use extract Cronux.bat to a folder of your choice, a sample use to open cmd as admin

```bash
Cronux sudo cmd
```

If you want Cronux to be available in your system path use the command below to add the folder into the **PATH** variable 

```bash
Cronux add-to-path C:/the/full/path/to/where/cronux.bat/is/
```

### Available Commands

The following linux command has been implemented the command operation is as expected and behave exactly the same as the Linux commands.

```bash
help, ls, wget, download, irs, sudo, elevate, su, clear
```

### Contributing

If you have any issue or you just want more command to be added you can file a request [issue](https://github.com/Thecarisma/Cronux/issues/new) 
anytime and if you just add a more interesting, fun and usefull command do not hesitate to send a 
[pull request](https://github.com/Thecarisma/Cronux/compare) 

### License

GNU Lesser General Public License v3.0 Copyright (c) 2019 Azeez Adewale Built with :heart: in Nigeria

