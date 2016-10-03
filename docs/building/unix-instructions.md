# Building On Unix

To build SassC, you must have either local copy of the LibSass source or it must be installed into your system. For development, please use the source version. You must then setup an environment variable pointing to the libsass folder, like:

```bash  
export SASS_LIBSASS_PATH=/Users/you/path/libsass
```

The executable will be in the bin folder. To run it, simply try something like

```bash
./bin/sassc [input file] > output.css
```

# Step-by-step

1. Clone the libsass repo:
    ```bash
    git clone https://github.com/sass/libsass.git
    ```

2. Edit your .bash_profile to include libsass directory:
    ```bash
    export SASS_LIBSASS_PATH=/Users/you/path/libsass
    ```

3. Clone the sassC repo
    ```bash
    git clone https://github.com/sass/sassc.git
    ```

4. cd into the sassC repo
    ```bash
    cd ./sassc
    ```

5. Type 'make'
   ```bash
   make
   ```

6. Job done!
