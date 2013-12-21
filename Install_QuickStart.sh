#!/bin/bash

clear

if [ ! -e "/usr/bin/zenity" ]; then

echo ""
echo " QuickStart was unable to find the 'Zenity' component it needs to run."
echo ""
echo -n " Please enter your password below to install it or 
 press CTRL + C to exit this installer."
echo ""
echo ""
sudo apt-get install zenity
fi

clear
echo ""
echo -n "Downloading QuickStart... "
sleep 1
echo ""
echo ""

cd $HOME/Desktop

wget http://quickstartdownload.pbwiki.com/f/QuickStart.tar.gz

echo ""
echo ""
echo -n "Installing QuickStart... "
sleep 1


if [ ! -e "$HOME/QuickStart" ]; then

mkdir $HOME/QuickStart

fi

tar xzf $HOME/Desktop/QuickStart.tar.gz -C $HOME

echo "
[Desktop Entry]
Name=QuickStart
Comment=System Utilities
Exec=$HOME/QuickStart/QuickStart
Icon=/usr/share/icons/gnome/scalable/categories/applications-utilities.svg
Terminal=false
Type=Application
StartupNotify=true
Categories=Application;Utility;" > $HOME/Desktop/QuickStart.desktop

echo ""
echo ""

cp $HOME/Desktop/QuickStart.desktop $HOME/QuickStart
sudo mv $HOME/Desktop/QuickStart.desktop /usr/share/applications

# Clean Up After Download and Install

sudo rm $HOME/Desktop/QuickStart.tar.gz
rm $HOME/Desktop/Install_QuickStart.sh

clear
echo ""
echo -n " QuickStart has been installed to the $HOME/QuickStart
 folder.

 You can now access QuickStart from the Main menu by selecting 
 APPLICATIONS -> ACCESSORIES -> QuickStart
 
 If you are running the Ubuntu 64-bit Operating System, you may
 still need to install the 'lib' files to run this 32-bit program.
 To do so, refer to my original post in the forum that gives you 
 the terminal command if you haven't already done so.

 http://quickstart.phpbb.net/viewtopic.php?f=8&t=11

 Enjoy... 


Press Enter to Continue: "
read
exit


