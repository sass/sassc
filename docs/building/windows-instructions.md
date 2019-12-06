# Building On Windows

To build SassC, the following pre-requisites must be met:

* Local copy of the LibSass source.
* Visual Studio 2013 Express for Desktop or higher.

Additionally, it is recommended to have `git` installed and available in `PATH`, so to deduce the `libsass` and `sassc` version information. For instance, if GitHub for Windows (https://windows.github.com/) is installed, the `PATH` will have an entry resembling: `X:\Users\<YOUR_NAME>\AppData\Local\GitHub\PortableGit_<SOME_GUID>\cmd\` (where `X` is the drive letter of system drive). If `git` is not available, inquiring the LibSass and SassC versions will result in `[NA]`.

> Note that with `Debug` or `Release` we statically compile VC runtime libraries (e.g. `MSVCP140.dll`) in sassc.exe which result in self-dependent / portable binary that is comparatively large in size. There are separate build configurations for shared runtime: `Debug without static runtime` and `Release without static runtime`, which produce the binary dependent on [VS2015 Redistributable package](https://www.microsoft.com/en-gb/download/details.aspx?id=48145) on the target system. If your target system (where you want to execute sassc.exe) already has VCR (via redistributable pack or Visual Studio itself), it is highly recommended to use this shared configuration. This way when the shared runtime libs receive an updated (performance improvements or bug fixes), the statically compiled image will not be able to take advantage of such updates.

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

Otherwise download LibSass and SassC sources from github, unzip and arrange so the structure looks like: `libsass\sassc`. If you want LibSass repo directory to be placed somewhere else, then set the environment variable `LIBSASS_DIR` with relative path based at the location of `sassc.sln`.

## From Visual Studio:
Open `projects\libsass\sassc\win\sassc.sln`, and do the finger dance `Ctrl+Shift+B` (or right-click sassc.sln and select Build) to build `sassc.exe`.

Visual Studio will form the filtered source tree as shown below:

![image](https://cloud.githubusercontent.com/assets/3840695/9313507/f4da01f0-452b-11e5-9276-bed0acc06263.png)

`Header Files` contains the `.h` and `.hpp` files, while `Source Files` covers `.c` and `.cpp` of SassC. `LibSass\Header Files` and `LibSass\Source Files` contain headers and source of LibSass. The other used headers/sources will appear under `External Dependencies`. 

The executable will be in the bin folder under sassc (`sassc\bin\sassc.exe`).

## From Command Line Interface:

Notice that in the following commands:

* If the platform is 32-bit Windows, replace `ProgramFiles(x86)` with `ProgramFiles`.
* To build with Visual Studio 2015, replace `12.0` with `14.0` in the aforementioned command.
* To build 32-bit binary, add `/p:Platform=Win32`.
* To build 64-bit binary, add `/p:platform=Win64`.

For example, in `cmd`, run:

```cmd
cd projects\libsass\sassc

:: 32-bit debug build with statically compiled runtime libs:
"%ProgramFiles(x86)%\MSBuild\12.0\Bin\MSBuild" win\sassc.sln ^
/p:Configuration=Debug /p:Platform=Win32
```

In `PowerShell`, the above variant would be:

```powershell
cd projects\libsass\sassc

# 64-bit release build without statically compiled runtime libs:
&"${env:ProgramFiles(x86)}\MSBuild\12.0\Bin\MSBuild" win\sassc.sln `
/p:Configuration='Release without static runtime' /p:Platform=Win64
```

You can also override the `LIBSASS_DIR` path by augmenting msbuild properties, such as: `/p:LIBSASS_DIR=../../some/path/leading/to/libsass;Configuration=Release`.

The executable will be in the bin folder under sassc (`sassc\bin\sassc.exe`). To run it, simply try something like

```cmd
sassc\bin\sassc [input file] > output.css
```
