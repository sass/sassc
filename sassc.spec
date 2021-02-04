Name:           sassc
Version:        3.1.0
Release:        1%{?dist}
Summary:        A wrapper around libsass

License:        MIT
URL:            http://libsass.org
Source0:        %{name}-%{version}.tar.gz

BuildRequires:  libsass >= 3.1
BuildRequires:  gcc-c++ >= 4.7
BuildRequires:  autoconf
BuildRequires:  automake
BuildRequires:  libtool
Requires:       libsass >= 3.1

%description
SassC is a wrapper around libsass used to generate a useful command-line application that can be installed and packaged for several operating systems.

%prep
%setup -q
autoreconf --force --install


%build
export SASSC_VERSION="%{version}"; %configure
make %{?_smp_mflags}


%install
%make_install


%files
%doc Readme.md LICENSE
%{_bindir}/%{name}


%changelog
* Tue Feb 10 2015 Gawain Lynch <gawain.lynch@gmail.com> - 3.1.0-1
- Initial SPEC file

