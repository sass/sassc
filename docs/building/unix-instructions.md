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

1. Type 'script/bootstrap' to clone [`libsass`](https://github.com/sass/libsass) and [`sass-spec`](https://github.com/sass/sass-spec) into the parent directory
   ```bash
   script/bootstrap
   ```
Alternately, if you already have libsass cloned or installed, you can edit your `.bash_profile` to include libsass directory:
    ```bash
    export SASS_LIBSASS_PATH=/Users/you/path/libsass
    ```

1. Type 'make'
   ```bash
   make
   ```

1. Job done!
