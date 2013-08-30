#!/bin/bash
SHOW_NEWS=0
CHECKSUM=$(md5sum /etc/xen.motd | awk '{print $1}')
if [ -f ~/.motd.checksum ]; then
	SAVED_CHECKSUM=$(cat ~/.motd.checksum)
	if [[ $CHECKSUM -ne $SAVED_CHECKSUM ]]; then
		echo "echo $CHECKSUM > ~/.motd.checksum"
		echo $CHECKSUM > ~/.motd.checksum
		SHOW_NEWS=1
	fi
else
	
	echo $CHECKSUM > ~/.motd.checksum
	SHOW_NEWS=1
fi

if [ $SHOW_NEWS -gt 0 ]; then
	more /etc/xen.motd
	sleep 5
fi
	

while [ 1 == 1 ] ; do
	clear
	OPTIONS="view_news change_password connect_to_server shutdown_server set_user_account_name logout help"
	select opt in  	$OPTIONS; do
	if [ "$opt" = "logout" ] ; then
		echo "Bye bye!"
		exit
	elif [ "$opt" = "help" ] ; then
		more /etc/xen.help
		echo "press ENTER to continue"
		read BLAH
		break
	elif [ "$opt" = "view_news" ] ; then
		more /etc/xen.motd
		echo "press ENTER to continue"
		read BLAH
		break
	elif [ "$opt" = "shutdown_server" ] ; then
		sudo /usr/sbin/xm shutdown $USER
		echo "Server has been shutdown"
		echo "press ENTER to continue"
		read BLAH
		break
	elif [ "$opt" = "change_password" ] ; then
		/usr/bin/passwd
		echo "press ENTER to continue"
		read BLAH
		break
	elif [ "$opt" = "connect_to_server" ] ; then
		exec /usr/local/bin/attach_xen.bash ~/.xen.target_user
		break
	elif [ "$opt" = "set_user_account_name" ] ; then
		echo "Please enter the name of your user account on your virtual server"
		read DESIRED_USER_NAME
		echo "You have entered $DESIRED_USER_NAME .  If this is incorrect, rechoose the set_user_account_name option from the menu"
		echo $DESIRED_USER_NAME > ~/.xen.target_user
		echo "press ENTER to continue"
		read BLAH
		break
	else
		echo "sorry, that isn't an option"
		echo "press ENTER to continue"
		read BLAH
		break
	fi
	done
done
