#! /bin/sh
# Configure your paths and filenames
SOURCEBINPATH=.
SOURCEDIR=network/
SOURCEBIN=network/pech.lua
IFACEBIN=iface-wrapper
CONNBIN=connect-wrapper
SOURCEDOC=README.md
DEBFOLDER=awesome-network-manager

DEBVERSION=$(date +%Y%m%d)

cd $DEBFOLDER

git pull origin master

DEBFOLDERNAME="../$DEBFOLDER-$DEBVERSION"
DEBPACKAGENAME=$DEBFOLDER\_$DEBVERSION

rm -rf $DEBFOLDERNAME
# Create your scripts source dir
mkdir $DEBFOLDERNAME

# Copy your script to the source dir
cp -R $SOURCEBINPATH/ $DEBFOLDERNAME/
cd $DEBFOLDERNAME

pwd

# Create the packaging skeleton (debian/*)
dh_make -s --indep --createorig 

mkdir -p debian/tmp/usr
cp -R usr debian/tmp/usr

# Remove make calls
grep -v makefile debian/rules > debian/rules.new 
mv debian/rules.new debian/rules 

# debian/install must contain the list of scripts to install 
# as well as the target directory
echo etc/xdg/awesome/rc.lua.pech.example etc/xdg/awesome >> debian/install
echo etc/xdg/awesome/$SOURCEBIN etc/xdg/awesome/$SOURCEDIR >> debian/install
echo usr/bin/$IFACEBIN usr/bin >> debian/install
echo usr/bin/$CONNBIN usr/bin >> debian/install
echo usr/share/doc/$DEBFOLDER/$SOURCEDOC usr/share/doc/$DEBFOLDER >> debian/install

echo "Source: $DEBFOLDER
Section: unknown
Priority: optional
Maintainer: cmotc <cmotc@openmailbox.org>
Build-Depends: debhelper (>= 9)
Standards-Version: 3.9.5
Homepage: https://www.github.com/cmotc/awesome-network-manager
#Vcs-Git: git@github.com:cmotc/awesome-network-manager
#Vcs-Browser: https://www.github.com/cmotc/awesome-network-manager

Package: $DEBFOLDER
Architecture: all
Depends: lightdm, lightdm-gtk-greeter, awesome (>= 3.4), \${misc:Depends}
Description: A networkmanager widget for awesomewm
" > debian/control

#echo "gsettings set org.gnome.desktop.session session-name awesome-gnome
#dconf write /org/gnome/settings-daemon/plugins/cursor/active false
#gconftool-2 --type bool --set /apps/gnome_settings_daemon/plugins/background/active false
#" > debian/postinst
# Remove the example files
rm debian/*.ex
rm debian/*.EX

# Build the package.
# You  will get a lot of warnings and ../somescripts_0.1-1_i386.deb
debuild -us -uc >> ../log
