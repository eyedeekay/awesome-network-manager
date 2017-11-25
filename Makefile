
dummy:

install:
	install usr/bin/connect-wrapper /usr/local/bin
	install usr/bin/iface-wrapper /usr/local/bin
	install usr/bin/iface-list /usr/local/bin
	install usr/bin/wireless-list /usr/local/bin
	install usr/bin/password-wrapper /usr/local/bin
	install usr/bin/password-encrypt /usr/local/bin
	mkdir -p /etc/xdg/awesome/network/
	install etc/xdg/awesome/network/pech.lua /etc/xdg/awesome/network/

remove:
	rm -rfv /usr/bin/connect-wrapper \
	 /usr/bin/iface-wrapper \
	 /usr/bin/iface-list \
	 /usr/bin/wireless-list \
	 /usr/local/bin/connect-wrapper \
	 /usr/local/bin/iface-wrapper \
	 /usr/local/bin/iface-list \
	 /usr/local/bin/wireless-list \
	 /etc/xdg/awesome/network/pech.lua

check:
	shellcheck usr/bin/connect-wrapper \
	 usr/bin/iface-wrapper \
	 usr/bin/iface-list \
	 usr/bin/wireless-list \
	 usr/bin/password-wrapper \
	 usr/bin/password-encrypt

