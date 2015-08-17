# Building On Windows

To build SassC, the following pre-requisites must be met:

* Local copy of the LibSass source and `sassc` directory in the root of `libsass`.
* Visual Studio 2013 Express for Desktop or higher.

Additionally, it is recommended to have `git` installed and available in `PATH`, so to deduce the `libsass` and `sassc` version information. For instance, if GitHub for Windows (https://windows.github.com/) is installed, the `PATH` will have an entry resembling: `X:\Users\<YOUR_NAME>\AppData\Local\GitHub\PortableGit_<SOME_GUID>\cmd\` (where `X` is the drive letter of system drive). If `git` is not available, inquiring the LibSass and SassC versions will result in `[NA]`.

## Obtaining the Sources:

If `git` in available in `PATH`, open `cmd` or `PowerShell` and run:

```cmd
:: clone LibSass repository:
cd projects
git clone https://github.com/sass/libsass

:: clone SassC repository inside `libsass\`:
cd libsass
git clone https://github.com/sass/sassc
```

Otherwise download LibSass and SassC sources from github, unzip and arrange so the structure looks like: `libsass\sass`.

## From Visual Studio:
Open `projects\libsass\sassc\win\sassc.sln`, and do the finger dance `Ctrl+Shift+B` to build `sassc.exe`.

Visual Studio will form the filtered source tree as shown below:

![image](https://cloud.githubusercontent.com/assets/3840695/9313507/f4da01f0-452b-11e5-9276-bed0acc06263.png)

`Header Files` contains the `.h` and `.hpp` files, while `Source Files` covers `.c` and `.cpp` of SassC. `LibSass\Header Files` and `LibSass\Source Files` contain headers and source of LibSass. The other used headers/sources will appear under `External Dependencies`. 

The executable will be in the bin folder under sassc (`sassc\bin\sassc.exe`).

## From Command Line Interface:

Notice that in the following commands:

* If the platform is 32-bit Windows, replace `ProgramFiles(x86)` with `ProgramFiles`.
* To build with Visual Studio 2015, replace `12.0` with `14.0` in the aforementioned command.

In `cmd`, run:

```cmd
cd projects\libsass\sassc

:: debug build:
"%ProgramFiles(x86)%\MSBuild\12.0\Bin\MSBuild" win\sassc.sln

:: or release build:
"%ProgramFiles(x86)%\MSBuild\12.0\Bin\MSBuild" win\sassc.sln /p:Configuration=Release
```

In `PowerShell`, the above variant would be:

```powershell
cd projects\libsass\sassc

# debug build:
"${env:ProgramFiles(x86)}\MSBuild\12.0\Bin\MSBuild" win\sassc.sln

# or release build:
"${env:ProgramFiles(x86)}\MSBuild\12.0\Bin\MSBuild" win\sassc.sln /p:Configuration=Release
```

The executable will be in the bin folder under sassc (`sassc\bin\sassc.exe`). To run it, simply try something like

```cmd
sassc\binsassc [input file] > output.css
```
