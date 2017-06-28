#!/bin/bash
# @author: Gary Cornell for devCU Software
# @contact: support@devcu.com
# @Facebook: facebook.com/garyacornell
# Created for Ubuntu 16x Servers running PHP 7 - Please Read Comments in Code for Proper Configuration
# MAIN: http://www.devcu.com 
# REPO: http://www.devcu.net
# Created:   06/15/2016
# Updated:   06/28/2017

# Default sytem values-
# You may edit these to match your system setup
# If altering HOME_PARTITION be sure to modify /etc/adduser.conf to match
HOME_PARTITION='home'
ROOT_DIRECTORY='public_html'
WEB_SERVER_GROUP='www-data'
# PHP7 packages that will be installed or updated. Please add or remove the packages to suit your needs
PHP7_PACKAGES='fcgiwrap php-fpm php-mysql php-curl php-gd php-intl php-pear php-imagick php-imap php-mcrypt php-apcu php-memcache php-mbstring php-sqlite3 php-tidy php-xmlrpc php-xml'
# Path defaults below, shouldnt need editing on most system setups
NGINX_SITES_AVAILABLE='/etc/nginx/sites-available'
NGINX_SITES_ENABLED='/etc/nginx/sites-enabled'
NGINX_CONFD='/etc/nginx/conf.d'
PHP_INI_DIR='/etc/php/7.0/fpm/pool.d'
NGINX_INIT='/etc/init.d/nginx restart'
PHP_FPM_INIT='/etc/init.d/php7.0-fpm restart'
PHP_FPM_INI='/etc/php/7.0/fpm/'
PHP_CLI_INI='/etc/php/7.0/cli/'
APT_SOURCES='/etc/apt/sources.list'
NGINX_MAINLINE='http://nginx.org/packages/mainline/ubuntu/'
# --------------END 
asd() {
cat <<"EOT"

    .-"^`\                                        /`^"-.
  .'   ___\                                      /___   `.
 /    /.---.                                    .---.\    \
|    //     '-.  ___________________________ .-'     \\    |
|   ;|         \/--------------------------//         |;   |
\   ||       |\_)      devCU Software      (_/|       ||   /
 \  | \  . \ ;  |         Presents         || ; / .  / |  /
  '\_\ \\ \ \ \ |                          ||/ / / // /_/'
        \\ \ \ \|     Nginx Ubuntu 2.02    |/ / / //
         `'-\_\_\       Setup Script       /_/_/-'`
                '--------------------------'
EOT
}

asd

      echo -e "\nJust double checking your setup, /$HOME_PARTITION partition with $ROOT_DIRECTORY as your root ?"

      read -p "If yes then hit ENTER and lets go..."
      echo""

# Check Nginx installed and version

     echo "Checking if Nginx is installed"
    if ! which nginx > /dev/null 2>&1; then
     echo "Nginx not installed"
    else
     echo -e "Nginx is installed you can skip the next step\n"
     nginx -v
    fi


# Install and/or upgrade Nginx to mainline
      echo -e  "\nDo you want to install Nginx fcgiwrap (Skip if Nginx is installed) (y/n)"
      read INSTALLNGINX
   if [ $INSTALLNGINX == "y" ]; then
      echo -e  "\nChecking if Nginx mainline repo exists"
   if grep -q $NGINX_MAINLINE $APT_SOURCES; then
      echo "Great! we found '$NGINX_MAINLINE' lets install:"
      echo -e  "\nLooking for latest nginx, this may take a few seconds..."
      apt -qq update
      apt install nginx -y
      nginx -v
      echo -e "\nNginx Updated"
   else
      echo "We couldnt find '$NGINX_MAINLINE' adding it now and updating:"
      echo "deb http://nginx.org/packages/mainline/ubuntu/ xenial nginx" >> $APT_SOURCES
      echo "deb-src http://nginx.org/packages/mainline/ubuntu/ xenial nginx" >> $APT_SOURCES
      apt clean
      echo "Grabbing signing key"
      cd /tmp
      wget http://nginx.org/packages/keys/nginx_signing.key
      cat nginx_signing.key | sudo apt-key add -
      echo -e  "\nLooking for nginx update, this may take a few seconds..."
      apt -qq update
      apt-get install nginx -y
      nginx -v
      echo -e "\nNginx installed successfully\n"
   fi
   else
      echo -e "\nSkipping Nginx mainline install\n"
   fi

     if [ $INSTALLNGINX == "y" ]; then
     echo -e "\nNginx updated to latest version\n"
   else
     echo "Do you want to upgrade Nginx to latest mainline version (Check for an updated version) (y/n)"
     read CHECKNGINX
   if [ $CHECKNGINX == "y" ]; then
     echo -e  "\nChecking if Nginx mainline repo exists"
   if grep -q $NGINX_MAINLINE $APT_SOURCES; then
     echo "Great! we found '$NGINX_MAINLINE' lets update:"
     echo -e  "\nLooking for nginx update, this may take a few seconds..."
     apt -qq update
     apt install nginx -y
     nginx -v
     echo -e "\nNginx Updated"
   else
     echo "We couldnt find '$NGINX_MAINLINE' adding it now and updating:"
     echo "deb http://nginx.org/packages/mainline/ubuntu/ xenial nginx" >> $APT_SOURCES
     echo "deb-src http://nginx.org/packages/mainline/ubuntu/ xenial nginx" >> $APT_SOURCES
     apt clean
     echo "Grabbing signing key"
     cd /tmp
     wget http://nginx.org/packages/keys/nginx_signing.key
     cat nginx_signing.key | sudo apt-key add -
     echo -e  "\nLooking for nginx update, this may take a few seconds..."
     apt -qq update
     apt install nginx -y
     nginx -v
     echo -e "\nNginx Updated\n"
   fi
   else
     echo -e "\nSkipping Nginx mainline update\n"
   fi
fi
# Check for system update
     echo "Do you want to check for system update (Recommended) (y/n)"
     read CHECKUPDATE
   if [ $CHECKUPDATE == "y" ]; then
      echo -e  "\nLooking for system updates, this may take a few seconds..."
      apt -qq update
      apt upgrade -y
      echo -e "\nSystem Updated\n"
   else
      echo -e "\nSkipping system update\n"
   fi
# Check for Kernel update
      echo "Do you want to check for kernel update (Recommended) (y/n)"
      read CHECKUPDATE
   if [ $CHECKUPDATE == "y" ]; then
      echo -e  "\nUpdating Kernel"
      apt install aptitude -y
      aptitude safe-upgrade -y
      echo -e "\nKernel Updated\n"
   else
      echo -e "\nSkipping kernel update\n"
   fi
# Install PHP
      echo "Do you want to install required PHP applications (Required) (y/n)"
      read CHECKPHP
   if [ $CHECKPHP == "y" ]; then
      echo -e "\nInstalling Required Applications"
      apt -qq update
      apt install $PHP7_PACKAGES
      echo -e "\nPHP Installed"
      echo -e "\nSystem Updated\n"
   else
      echo -e "\nSkipping PHP update\n"
   fi

# Security Update
      echo -e "\nSecurity Check - Generating 2048bit Diffie-Hellman for TLS"
   if [ -f /etc/ssl/certs/dhparam.pem ]
   then
      echo -e "\nGreat! the file exists\n"
   else
         echo -e "\nFile doesnt exist, creating now"
      openssl dhparam 2048 -out /etc/ssl/certs/dhparam.pem
   fi
      echo -e "\nFinsihed DH TLS Generation\n"

# -------
# PHP INI CONFIG:
# -------
      CURRENT_DIR=`dirname $0`
      echo -e "\nSecure PHP INI for FPM/CLI - \nThis will secure the following:\ncgi.fix_pathinfo=0\nexposephp=off\ndisable_functions = disable dangerous stuff"
      echo -e "\nSecurity Check - Do you want to secure your php.ini? (VERY Important!) (y/n)"
      read CHECKPHPINI
   if [ $CHECKPHPINI == "y" ]; then
      echo -e "\nMaking backups ups of original fpm and cli php.ini"
      sudo mv /etc/php/7.0/fpm/php.ini /etc/php/7.0/fpm/php.ini.bak
      sudo mv /etc/php/7.0/cli/php.ini /etc/php/7.0/cli/php.ini.bak
      echo -e "\nUpdating fpm and cli php.ini with secure rules"
      CONFIGFPM=$PHP_FPM_INI
      cp $CURRENT_DIR/php.ini $CONFIGFPM
      CONFIGCLI=$PHP_CLI_INI
      cp $CURRENT_DIR/php.ini $CONFIGCLI
      echo -e "\nphp.ini fpm and cli secured\n"
   else
      echo -e "\nNot a wise choice, We highly suggest securing your php.ini files\n"
   fi

     read -p "System is ready for your domain and user, hit ENTER to continue..."

# Confirgure Domain
     echo -e "\nCreate Web and User"

     SED=`which sed`
     CURRENT_DIR=`dirname $0`

   if [ -z $1 ]; then
     echo "No Domain Name Given"
	exit 1
   fi
     DOMAIN=$1

# Check the domain is valid!
     PATTERN="^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$";
   if [[ "$DOMAIN" =~ $PATTERN ]]; then
     DOMAIN=`echo $DOMAIN | tr '[A-Z]' '[a-z]'`
     echo "Creating Hosting For:" $DOMAIN
   else
     echo "Invalid Domain Name"
     exit 1
   fi

# Configure IP Address
     echo -n "Available Server IP Addresses "
     hostname -I
     echo -n "Enter Domain IP Address > "
     read IP
     echo "You Entered: $IP"

# Check if the servers IP is valid! Work in progress
#PATTERN="^(([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$";
#
#if [[ "$IP" =~ $PATTERN ]]; then
#	IP=`echo $IP | tr '[0-9]'`
#	echo "Creating Server IP For:" $IP
#else
#	echo "Invalid IP Address"
#	exit 1 
#fi

# Create a new user
     echo "Please Specify The Username then Password For This Site"
     read USERNAME
     HOME_DIR=$USERNAME
     adduser $USERNAME

# Create directories - files
     echo "Would You Like To Change The Web Root Directory, default is /$HOME_PARTITION/$HOME_DIR/$ROOT_DIRECTORY/ no (y/n)?"
     read CHANGEROOT
   if [ $CHANGEROOT == "y" ]; then
     echo "Enter the new web root dir (after the public_html/)"
     read DIR
     PUBLIC_HTML_DIR=/$ROOT_DIRECTORY/$DIR
   else
     PUBLIC_HTML_DIR=/$ROOT_DIRECTORY
   fi

# -------
# NGINX CONFIG:
# -------

     echo -e "\nMaking backup of original nginx.conf"
     sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
     echo -e "\nUpdating nginx.conf with optimization and secure rules\n"
     CONFIGCONF='/etc/nginx/'
     cp $CURRENT_DIR/nginx.conf $CONFIGCONF

     echo -e "\nCreate nginx $NGINX_SITES_AVAILABLE if doesnt exist"
   if [ -d "$NGINX_SITES_AVAILABLE" ]
   then
     echo -e "Directory $NGINX_SITES_AVAILABLE exists."
   else
     mkdir -p $NGINX_SITES_AVAILABLE
     echo -e "\nFinsihed directory creation"
   fi

     echo -e "\nCreate nginx $NGINX_SITES_ENABLED if doesnt exist"
   if [ -d "$NGINX_SITES_ENABLED" ]
   then
     echo -e "Directory $NGINX_SITES_ENABLED exists."
   else
     mkdir -p $NGINX_SITES_ENABLED
     echo -e "\nFinsihed directory creation"
   fi
   
     echo -e "\nCreate nginx $NGINX_CONFD if doesnt exist"
   if [ -d "$NGINX_CONFD" ]
   then
     echo -e "Directory $NGINX_CONFD exists."
   else
     mkdir -p $NGINX_CONFD
     echo -e "\nFinsihed directory creation"
   fi

# Create a new domain vhost
     CONFIG=$NGINX_SITES_AVAILABLE/$DOMAIN.vhost
     cp $CURRENT_DIR/nginx.vhost.template $CONFIG
     echo -e "\nInstalled vhost conf"

# -------
# NGINX VHOST:
# -------
     echo -e "\nCreate nginx vhosts.conf if doesnt exist"
   if [ -f /etc/nginx/conf.d/vhosts.conf ]
   then
     echo -e "\nGreat! the file exists"
   else
     echo -e "\nThe file doesnt exist, creating..."
     touch /etc/nginx/conf.d/vhosts.conf
     echo "include /etc/nginx/sites-enabled/*.vhost;" >>/etc/nginx/conf.d/vhosts.conf
   fi
     echo -e "\nFinsihed vhosts.conf creation"

$SED -i "s/@@HOSTNAME@@/$DOMAIN/g" $CONFIG
$SED -i "s/@@IPADD@@/$IP/g" $CONFIG
$SED -i "s#@@PATH@@#\/$HOME_PARTITION\/"$USERNAME$PUBLIC_HTML_DIR"#g" $CONFIG
$SED -i "s/@@LOG_PATH@@/\/$HOME_PARTITION\/$USERNAME\/logs/g" $CONFIG
$SED -i "s/@@SSL_PATH@@/\/$HOME_PARTITION\/$USERNAME\/ssl/g" $CONFIG
$SED -i "s#@@SOCKET@@#/var/run/"$USERNAME"_fpm.sock#g" $CONFIG

     echo "FPM max children, must be higher then max servers, try 8:"
     read MAX_CHILDREN
     echo -e "\n# start FPM servers, start servers must not be less than min spare servers and not greater than max spare servers, try 4:"
     read FPM_SERVERS
     echo -e "\nMin # spare FPM servers, try 2:"
     read MIN_SERVERS
     echo -e "\nMax # spare FPM servers, try 6:"
     read MAX_SERVERS

# Create a new php fpm pool config
     echo -e "\nInstall PHP FPM conf file"
     FPMCONF="$PHP_INI_DIR/$DOMAIN.conf"
     cp $CURRENT_DIR/conf.template $FPMCONF
$SED -i "s/@@USER@@/$USERNAME/g" $FPMCONF
$SED -i "s/@@GROUP@@/$USERNAME/g" $FPMCONF
$SED -i "s/@@HOME_DIR@@/\/$HOME_PARTITION\/$USERNAME/g" $FPMCONF
$SED -i "s/@@MAX_CHILDREN@@/$MAX_CHILDREN/g" $FPMCONF
$SED -i "s/@@START_SERVERS@@/$FPM_SERVERS/g" $FPMCONF
$SED -i "s/@@MIN_SERVERS@@/$MIN_SERVERS/g" $FPMCONF
$SED -i "s/@@MAX_SERVERS@@/$MAX_SERVERS/g" $FPMCONF

     echo -e "\nSet System Permissions"
     usermod -aG $USERNAME $WEB_SERVER_GROUP
     chmod g+rx /$HOME_PARTITION/$HOME_DIR
     chmod 600 $CONFIG
     ln -s $NGINX_SITES_AVAILABLE/$DOMAIN.vhost $NGINX_SITES_ENABLED/

# set file perms and create required dirs!
     echo -e "\nInstall web directories"
     mkdir -p /$HOME_PARTITION/$HOME_DIR$PUBLIC_HTML_DIR
     mkdir -p /$HOME_PARTITION/$HOME_DIR/logs
     mkdir -p /$HOME_PARTITION/$HOME_DIR/ssl
     mkdir -p /$HOME_PARTITION/$HOME_DIR/_sessions
     mkdir -p /$HOME_PARTITION/$HOME_DIR/backup

# Create a index.php placeholder page to avoid 403 error
     CONFIG=/$HOME_PARTITION/$HOME_DIR$PUBLIC_HTML_DIR/
     cp $CURRENT_DIR/index.php $CONFIG
     echo -e "\nInstalled basic index.php placeholder"

     echo -e "\nSet Web Directory Permissions"
     chmod 750 /$HOME_PARTITION/$HOME_DIR -R
     chmod 700 /$HOME_PARTITION/$HOME_DIR/_sessions
     chmod 770 /$HOME_PARTITION/$HOME_DIR/ssl
     chmod 770 /$HOME_PARTITION/$HOME_DIR/logs
     chmod 770 /$HOME_PARTITION/$HOME_DIR/backup
     chmod 750 /$HOME_PARTITION/$HOME_DIR$PUBLIC_HTML_DIR
     chmod 644 /$HOME_PARTITION/$HOME_DIR$PUBLIC_HTML_DIR/index.php
     chown $USERNAME:$USERNAME /$HOME_PARTITION/$HOME_DIR/ -R
     chown root:root /$HOME_PARTITION/$HOME_DIR/ssl -R
     chown root:root /$HOME_PARTITION/$HOME_DIR/backup -R
	 

     echo -e "\nRestart Services"
$NGINX_INIT
     echo
$PHP_FPM_INIT

     echo -e "\nUpdate Grub in case we upgraded kernel, you must reboot server if new Kernel is to be effective"
     update-grub

     echo -e "\nCleanup Files"
     apt autoremove
     apt autoclean

     echo -e "\nLooks like we are done, woo hoo! no errros"

     echo -e "\nWeb Created for $DOMAIN for user $USERNAME with PHP support"
