awesome-network-manager
==========================

This widget provides an interface to NetworkManager by sending commands to
nmcli. Right now it only lists managed interfaces and scans for networks in
the area.

To-Do:
------
   * Show all interfaces as menu items(Done)
   * Show wifi interfaces as submenu items(Done)
   * Optionally notify the user of new networks periodically(Done)
   * Trigger a scan of the nearby networks when the widget is clicked(Done, I think?)
   * Connect to wifi networks when the user clicks the submenu member(Works for unsecured networks, experimental support for secured networks)
   * Enable and Disable interfaces by clicking the interface menu item(Done)

Usage
-----

This widget is designed to mimic be similar to the pop-up/drop-down mouse driven
Wi-Fi management interfaces that are popular in heavier desktop environments
like Gnome and KDE.

###Interface Menu
The first click on the menu brings up a list of interfaces that can be used with
nmcli. Clicking on an element in this menu will bring the interface down or up.

![Screenshot of the Interface Menu](https://raw.githubusercontent.com/cmotc/awesome-network-manager/master/nm1.png)

###Wi-Fi Menu
Highlighting the Wi-Fi device in the interface list will bring up a list of
wireless AP's nearby. Clicking on an item in the list will attempt to connect to
the interface. Currently only works for Open AP's.

![Screenshot of the Wifi Menu](https://raw.githubusercontent.com/cmotc/awesome-network-manager/master/nm2.png)

Installation
------------

I'm trying to keep my Awesome plugins as simple as possible. First, copy the 
awesome/network/ folder into your awesome config folder. If you were in the
root of this repository, you could manually copy the file like this:  

        cd etc/xdg/awesome/ && cp -Rv network ~/.config/awesome/

and the wrapper scripts like this:

        cd usr/bin/ && sudo cp -v *-wrapper /usr/bin/ && sudo chmod a+x /usr/bin/*-wrapper

Once it's copied, just require the library at the top of your rc.lua, like so:  

        require("network.pech")

instantiate the menu:  

        -- create a network menu widget
        function mynetworkmenu()
            networkmenu = awful.menu({	items = netmgr.generate_network_menu()	  })
            return networkmenu
        end
        mynetworklauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                            menu = mynetworkmenu()})

and add your widget to your wibox:  

        right_layout:add(mynetworklauncher)

if you want to periodically scan for new access points, you can add these lines
to your rc.lua to create a timer:  

        nettimer = timer({ timeout = 360 })
        nettimer:connect_signal("timeout", function()
            mynetworklauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                                menu = mynetworkmenu()})
            end)
        nettimer:start()

Encrypting your Wi-Fi keys on disk
----------------------------------
Optionally, you can configure your wireless keys to be encrypted with GPG when
you aren't trying to connect to a network. If you also disable automatic
connections to AP's and any other caching facilities related to Wi-Fi passwords,
you might be able to protect them in some scenarios. Instructions for doing this
will be added here soon(When it's fully supported. You need to create a couple
config files and put them to somewhere the script will look for it.)

