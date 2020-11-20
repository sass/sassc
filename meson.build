project('sassc', 'c', version: '3.6.2', default_options: ['c_std=c11'])

sassc_version = configure_file(input: 'sassc_version.h.in', output: 'sassc_version.h',
  configuration: {
    'PACKAGE_VERSION': meson.version()
  }
)

deps = [
  dependency('libsass', required: true, fallback: ['sass', 'sass_dep'])
]

sass_exe = executable('sassc', 'sassc.c', dependencies: deps, install: true)
