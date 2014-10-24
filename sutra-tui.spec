Name:           sutra-tui
Version:        0.3
Release:        0%{?dist}
Summary:        Vedic Sutra

License:        GPLv3
URL:            https://github.com/sri-arjuna/tui-sutra
Source0:        %{name}-%{version}.tar.gz

Requires:       tui
Requires:       essentials
Requires:       %{name}-german

%description
Prints a random sutra from the Vedics upon a new terminal.
This package provides german sutra.

%prep
%setup -q -c %{name}-%{version}

%build
# Nothing to do

%install
rm -rf $RPM_BUILD_ROOT
##%make_install

mkdir -p %{buildroot}%{_bindir}/ \
         %{buildroot}%{_datarootdir}/%{name}
rm -fr %{name}/.git
mv %{name}/sutra.sh %{buildroot}%{_bindir}/sutra
mv %{name}/[RL]*  %{buildroot}%{_datarootdir}/%{name}

%files
%doc %{_datarootdir}/%{name}/README.md 
%doc %{_datarootdir}/%{name}/LICENSE
%{_bindir}/sutra

%changelog
* Fri Oct 24 2014 Simon A. Erat <erat.simon@gmail.com> 0.3
- Initial package
