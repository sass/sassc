#!/bin/sh

clone_unless_present() {
	[ -d "${1?clone_unless_present: need directory}" ] && return 0
	git clone "${2?clone_unless_present: need URL}" "${1}"
}

clone_unless_present ${SASS_LIBSASS_PATH:=../libsass} https://github.com/sass/libsass &&
clone_unless_present ${SASS_SPEC_PATH:=../sass-spec} https://github.com/sass/sass-spec || exit 1

export SASS_LIBSASS_PATH SASS_SPEC_PATH
