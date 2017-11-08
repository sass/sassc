# Building On Unix

To build SassC, you must have either local copy of the LibSass source or it must be installed into your system. For development, please use the source version.

The executable will be in the bin folder. To run it, simply try something like

```bash
./bin/sassc [input file] > output.css
```

# Step-by-step

1. Clone the SassC repo
    ```bash
    git clone https://github.com/sass/sassc.git
    ```

1. cd into the SassC repo
    ```bash
    cd ./sassc
    ```

1. Type "`. bootstrap.sh`" to clone [`libsass`](https://github.com/sass/libsass) and [`sass-spec`](https://github.com/sass/sass-spec) into the parent directory. Do not forget the dot in front!

   ```bash
   . bootstrap.sh
   ```
   Alternately, if you already have libsass cloned or installed, you can edit your `.bash_profile` to include libsass directory:
   ```bash
   SASS_LIBSASS_PATH=/Users/you/path/libsass
   export SASS_LIBSASS_PATH
   ```
   The following will let you provide the location of the [`sass-spec`](https://github.com/sass/sass-spec) testsuite:
   ```bash
   SASS_SPEC_SASS=/Users/you/favourite/sass-spec
   export SASS_SPEC_SASS
   ```
   You can add the above to `.profile` or `.bash_profile` in your home directory to have those added automatically for your every login session.

1. Type 'make'
   ```bash
   make
   ```

   Make sure you are using GNU make - `gmake` may be the command needed on some systems.

1. Install the whole thing if you like
   ```bash
   make install
   ```

   This will install sassc to `/usr/local/bin/sassc`. You can change the `/usr/local` part by setting `PREFIX` variable.

1. Job done!
