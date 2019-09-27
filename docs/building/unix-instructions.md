# Building On Unix

To build SassC, you must either have a local copy of the LibSass sources or
LibSass must already be installed in your system as a (shared) library with
development headers available (See [LibSass build instruction][1] for further
reference). LibSass and SassC can be built either via provided [Makefiles][3]
(preferred for local development) or via [autotools][2] (preferred for system
installs).

# Using the CI bootstrap script

This will need a git client available to fetch the dependencies.

1. Clone the SassC repo
    ```bash
    git clone https://github.com/sass/sassc.git
    ```

2. Run CI bootstrap script and import env-variables
    ```bash
    . sassc/script/bootstrap
    ```

3. Execute `make` to compile all sources
    ```bash
    make -C sassc -j4
    ```

    Make sure you are using GNU make, on some
    systems it may be called `gmake`.

4. The binary should be created in the `bin` folder
    ```bash
    ./sassc/bin/sassc [input file] > output.css
    ```

5. Optionally install the resulting binary
    ```bash
    PREFIX="/usr" make -C sassc install
    ```

# Environment variables for custom source locations

In case you have already cloned LibSass or the spec tests
in any other location, you can set the following environment
variables. To make these locations permanent add them to
your `.profile` or `.bash_profile` in your home directory:

```bash
SASS_LIBSASS_PATH=/Users/you/path/libsass
export SASS_LIBSASS_PATH
SASS_SPEC_SASS=/Users/you/favourite/sass-spec
export SASS_SPEC_SASS
```

# Manually building from git sources via github

```bash
SASS_LIBSASS_PATH=`pwd`/libsass
git clone https://github.com/sass/sassc.git
git clone https://github.com/sass/libsass.git
make -C sassc -j4
sassc/bin/sassc --version
```

# Manually building from tar sources via github

Note: it is not really recommended to use archive
downloads from github, as the build will show "na"
as the compiled version, since the info will be
directly derived from the git version (until you
pass the information manually to the build call)!

```bash
# select tagged versions
SASSC_VERSION="3.4.5"
LIBSASS_VERSION="3.4.5"
# download from github and unpack in one go
curl -L https://github.com/sass/sassc/archive/${SASSC_VERSION}.tar.gz | tar -xz;
curl -L https://github.com/sass/libsass/archive/${LIBSASS_VERSION}.tar.gz | tar -xz;
# set environment variable for sassc makefile
SASS_LIBSASS_PATH=`pwd`/libsass-${LIBSASS_VERSION}
# create version files for standalone build
echo $SASSC_VERSION > sassc-${SASSC_VERSION}/VERSION
echo $LIBSASS_VERSION > libsass-${LIBSASS_VERSION}/VERSION
# compile libsass and sassc binary
make -C sassc-${SASSC_VERSION} -j4
# check version of resulting binary
sassc-${SASSC_VERSION}/bin/sassc --version
```

# Build via autoconfig (preferred for system installs)

Please read [libsass autotools build instructions][2] first!  
LibSass must be compiled first with corresponding settings!  
Here we will compile and use LibSass as a shared library!  

## Get the sources

```bash
# using git is preferred
git clone https://github.com/sass/libsass.git
git clone https://github.com/sass/sassc.git
```

## Prerequisites

In order to run autotools you need a few tools installed on your system.

```bash
apt-get install autotools-dev autoconf libtool # Alpine
yum install automake libtool # RedHat Linux
emerge -a automake libtool # Gentoo Linux
pkgin install automake libtool # SmartOS
```

## Compile LibSass

### Create configure script

```bash
cd libsass
autoreconf --force --install
cd ..
```

### Create custom makefiles

```bash
cd libsass
./configure \
  --disable-tests \
  --enable-shared \
  --prefix=/usr
cd ..
```

### Build the library

```bash
make -C libsass -j4
```

### Install the library

```bash
make -C libsass install
```

## Compile SassC

### Create configure script

```bash
cd sassc
autoreconf --force --install
cd ..
```

### Create custom makefiles

```bash
cd sassc
./configure \
  --prefix=/usr
cd ..
```

### Build the binary

```bash
make -C sassc -j4
```

### Install the binary

The binary will be installed to the location given as `prefix` to `configure`.  
This is standard behavior for autotools and not `sassc` specific.

```bash
make -C sassc install
sassc --version
```

[1]: https://github.com/sass/libsass/blob/master/docs/build.md
[2]: https://github.com/sass/libsass/blob/master/docs/build-with-autotools.md
[3]: https://github.com/sass/libsass/blob/master/docs/build-with-makefiles.md
