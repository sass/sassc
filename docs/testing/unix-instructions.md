# Testing on Unix

The official libsass/sassc test suite is located at http://github.com/sass/sass-spec. It's a specialized project just to ensure that Sass works as expected. First, go clone (and ensure its up-to-date) the sass-spec repo. THEN, you must setup an environment variable to point to the spec folder. Also, if you want to test against the latest libsass, you MUST define the location of a copy of the libsass repo.

For instance, this is in my profile.

```bash
export SASS_SPEC_PATH=/Users/you/dev/sass/sass-spec
export SASS_SASSC_PATH=/Users/you/dev/sass/sassc
export SASS_LIBSASS_PATH=/Users/you/dev/sass/libsass
```

Then, run the SassC specific tests this way:

```bash
make test
```

Or, if you want to run the whole SassSpec suite

```bash
make test_spec
```
