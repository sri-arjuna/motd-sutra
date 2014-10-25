Name:           sutra-tui
Version:        0.3
Release:        0%{?dist}
Summary:        Vedic Sutra

License:        GPLv3
URL:            https://github.com/sri-arjuna/tui-sutra
Source0:        %{name}-%{version}.tar.gz

Requires:       tui
Requires:       essentials
#Requires:       %{name}-german

%description
Prints a random sutra from the Vedics upon a new terminal.

#%description "%{name}-german"
This package provides german sutra.

%prep
%setup -q -c %{name}-%{version}

%build
# Nothing to do

%install
rm -rf $RPM_BUILD_ROOT
##%make_install

mkdir -p %{buildroot}%{_bindir}/ \
         %{buildroot}%{_datarootdir}/%{name}/lang \
         %{buildroot}/%{_mandir}/man1
rm -fr %{name}/.git
mv %{name}/sutra.sh %{buildroot}%{_bindir}/sutra
mv %{name}/[RL]*  %{buildroot}%{_datarootdir}/%{name}
mv %{name}/sutra.1 %{buildroot}/%{_mandir}/man1

##install %{name}-german
mkdir -p %{buildroot}%{_datarootdir}/%{name}/lang
mv %{name}/lang/[Gg]erman %{buildroot}%{_datarootdir}/%{name}/lang

%files
%doc %{_datarootdir}/%{name}/README.md 
%doc %{_datarootdir}/%{name}/LICENSE
%doc %{_mandir}/man1/sutra.1.gz
%{_bindir}/sutra

#%files %{name}-german
%{_datarootdir}/%{name}/lang/German
%{_datarootdir}/%{name}/lang/german

%changelog
* Fri Oct 24 2014 Simon A. Erat <erat.simon@gmail.com> 0.3
- Initial package
