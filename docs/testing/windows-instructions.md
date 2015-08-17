# Testing on Windows

The official libsass/sassc test suite is located at http://github.com/sass/sass-spec. It's a specialized project just to ensure that Sass works as expected. To run the libsass tests, Ruby should be installed in your system. Download https://www.ruby-lang.org/en/downloads/.

After [building SassC](../building/windows-instructions.md), run the SassC specific tests this way:

```cmd
:: `ruby` should be available in PATH
:: install a required ruby gem for testing:
gem install minitest

:: enter the libsass directory
cd libsass

:: clone sass-spec repo
git clone https://github.com/sass/sass-spec

:: run entire test suite
ruby sass-spec/sass-spec.rb -c sassc/bin/sassc -s sass-spec/spec
```

If you want to skip the tests for known bugs:

```cmd
ruby sass-spec/sass-spec.rb -c sassc/bin/sassc -s --ignore-todo sass-spec/spec
```
