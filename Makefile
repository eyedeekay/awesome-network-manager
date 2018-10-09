
dummy:

install:
	install usr/bin/connect-wrapper /usr/local/bin
	install usr/bin/iface-wrapper /usr/local/bin
	install usr/bin/iface-list /usr/local/bin
	install usr/bin/wireless-list /usr/local/bin
	install usr/bin/password-wrapper /usr/local/bin
	install usr/bin/password-encrypt /usr/local/bin
	mkdir -p /etc/xdg/awesome/network/
	install etc/xdg/awesome/network/netmgr.lua /etc/xdg/awesome/network/

remove:
	rm -rfv /usr/bin/connect-wrapper \
	 /usr/bin/iface-wrapper \
	 /usr/bin/iface-list \
	 /usr/bin/wireless-list \
	 /usr/local/bin/connect-wrapper \
	 /usr/local/bin/iface-wrapper \
	 /usr/local/bin/iface-list \
	 /usr/local/bin/wireless-list \
	 /etc/xdg/awesome/network/netmgr.lua

check:
	shellcheck usr/bin/connect-wrapper \
	 usr/bin/iface-wrapper \
	 usr/bin/iface-list \
	 usr/bin/wireless-list \
	 usr/bin/password-wrapper \
	 usr/bin/password-encrypt

install-home:
	mkdir -p $(HOME)/.config/awesome/network
	cp etc/xdg/awesome/network/netmgr.lua $(HOME)/.config/awesome/network

deb:
	checkinstall -y \
		--nodoc \
		--install=no \
		--pkgname=awesome-network-manager \
		--pkgsource=awesome-network-manager \
		--pkgversion=1 \
		--pkglicense=gpl \
		--pkggroup=x11 \
		--maintainer=eyedeekay@safe-mail.net \
		--pakdir=.. \
		--requires="wicd-cli | nmcli, awesome" \
		--deldoc=yes \
		--deldesc=yes \
		--delspec=yes \
		--backup=no
	rm -f description-pak
