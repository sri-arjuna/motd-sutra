Name:           sutra-tui
Version:        0.4
Release:        9%{?dist}
Summary:        Vedic Sutra

License:        GPLv3
URL:            https://github.com/sri-arjuna/tui-sutra
Source0:        %{name}-%{version}.tar.gz

BuildArch:       noarch

Requires:       tui
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
         %{buildroot}/%{_mandir}/man1 \
         %{buildroot}/%{_sysconfdir}/profile.d
rm -fr %{name}/.git
#mv %{name}/sutra.sh %{buildroot}%{_bindir}/sutra
mv %{name}/sutra2 %{buildroot}%{_bindir}/sutra
mv %{name}/[RL]*  %{buildroot}%{_datarootdir}/%{name}
mv %{name}/sutra.1 %{buildroot}/%{_mandir}/man1
mv %{name}/%{name}.sh %{buildroot}%{_sysconfdir}/profile.d/

##install %{name}-german
mkdir -p %{buildroot}%{_datarootdir}/%{name}/lang
mv %{name}/lang/* %{buildroot}%{_datarootdir}/%{name}/lang

%files
%doc %{_datarootdir}/%{name}/README.md 
%doc %{_datarootdir}/%{name}/LICENSE
%doc %{_mandir}/man1/sutra.1.gz
%{_bindir}/sutra
%{_sysconfdir}/profile.d/%{name}.sh

#%files %{name}-german
%{_datarootdir}/%{name}/lang/[Gg][eE][rR][mM][aA][nN]

%changelog
* Tue Feb 24 2015 Simon A. Erat <erat.simon@gmail.com> 0.4.9
- Massive rewrite & start optimization
- Using now language file for help text output.

* Mon Feb 02 2015 Simon A. Erat <erat.simon@gmail.com> 0.0.4
- Changed german sutra files to utf8-w/o-bomS

* Mon Jan 19 2015 Simon A. Erat <erat.simon@gmail.com> 0.0.3
- Change algorythm and structure

* Fri Oct 24 2014 Simon A. Erat <erat.simon@gmail.com> 0.0.1
- Initial package
