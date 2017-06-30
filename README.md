![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)  ![Version](https://img.shields.io/badge/Version-2.03-blue.svg)  ![Development](https://img.shields.io/badge/Development-Active-blue.svg)

# nginxubuntu-php7

<pre>
    .-"^`\                                        /`^"-.
  .'   ___\                                      /___   `.
 /    /.---.                                    .---.\    \
|    //     '-.  ___________________________ .-'     \\    |
|   ;|         \/--------------------------//         |;   |
\   ||       |\_)      devCU Software      (_/|       ||   /
 \  | \  . \ ;  |         Presents         || ; / .  / |  /
  '\_\ \\ \ \ \ |                          ||/ / / // /_/'
        \\ \ \ \|     Nginx Ubuntu 2.03    |/ / / //
         `'-\_\_\       Setup Script       /_/_/-'`
                '--------------------------'
</pre>

A bash script that automates Nginx, PHP7,  PHP-FPM, Percona MySQL 5.7 and User/Domain setup in a couple minutes. For NEW/Fresh server installs but can be used to setup-add new user/domain and directory structure anytime

Created for Ubuntu 16x Servers but should work on all Debian flavors that support PHP7 - Please Read Comments in Code for Proper or custom Configuration

Uses a standard $HOME/$USER/public_html directory setup but can be edited for any type directory structure

## Dime a dozen! So why this one?

Yes there are many of these scripts out there so why is this one different? Anyone can bash code "apt install nginx" but I have also included optimized configuration files as well as calling on my 15 years of experience as a server admininstrator to make sure the latest security features are available in the config files. Making sure all necessary directories are created properly and all permissions are correct on all relevant directories. There are very few scripts that actually do the configuring as well making it possible to access your domain instantly with very little or no additional configuration needed. Its throughly tested and in active development to add more features as well as update anything that needs updating :>. If anyone has suggestions or advice to better the script I am all ears.

## Optional

- Optional runs a apt update/upgrade (recommended)

- Optional install (new systems) or upgrade latest mainline Nginx (recommended)

- Optional PHP7 install w/dependencies

- Optional Percona MySQL Server 5.7 install and my.cnf optimization

- Optional php.ini updated and secured (recommended)

- Generates 2048 Diffie-Hellman for TLS if it doesnt exist (recommended)(OpenSSL required)

- Editable options see below

## Functions

- Setup/Create Nginx directory structure, sites_available / sites_enabled / domain.vhost conf / conf.d (if doesnt exist)

- Updates cgi.fix_pathinfo=0 in fpm and cli php.ini and disables dangerous PHP functions (if doesnt exist)

- Setup/Create php-fpm directory structure, domain.conf (if doesnt exist)

- Setup/Create user/pass with domain/IP and public_html directory structure

- Setup/Create Nginx gzip mime types and relevant cache directories (editable in nginx.conf)

- Sets all proper permissions on relevant directories.

- Restarts via init

- Adds index.php skel to public directory


### Creates the following $HOME directory structure

The script by default uses the following structure but can be edited to accomadate any type setup IE /var/www , /var/htdocs, etc...Your choice.

* $HOME
    * $USER
        * _sessions
        * backups
        * logs
        * public_html
             * index.php
        * ssl
        
        
## Editable

See [/src/auto_create_web.sh](https://github.com/GaryCornell/nginxubuntu-php7/blob/master/src/auto_create_web.sh) for editable fields

## Simple Usage as root

1. cd /opt  (Any directory you choose is fine)

2. wget https://github.com/GaryCornell/nginxubuntu-php7/archive/2.02.tar.gz

3. tar -xvzf 2.02.tar.gz

4. cd nginxubuntu-php7-2.02/src/

5. chmod u+x auto_create_web.sh

6. ./auto_create_web.sh yourdomain.com

7. Just follow the prompts

8. Edit domain.vhost accordingly. The vhost is updated with the latest security features for SSL if using a cert you must uncomment and make sure paths are correct. The script sets up the standard path $HOME/$USER/ssl to cert/key/trusted_chain.pem but of course you must supply the files. root path/logs path/php-fpm unix socket and sessions paths are setup and work out of the box for you but can be edited for custom paths.

9. Once completed:
Local Server: Go to your sites web address (EX: http://loacalhost:8080 ) and start building immediately!
Remote Server: if your DNS is setup then you can access your site immediately (EX: http://www.domain.com )

## Proposed Additions (All optional)
- Percona MySQL 5.7 Server setup
- Bind9 DNS fully configured and ready to go
- Postfix/Dovecot mail server with all the bells and whistles
- vsftpd setup and configuration
- More? >:

## License

Apache License 2.0

## Development / Contribute

Further development is planned but any serious functionality issues or security issues will be addressed if discovered by me or reported by users. I welcome code efficiency and optimization comments. I have extensive knowledge in server setup, security and optimization, whatever makes it easier is my moto. The issue is not if I can its if I have the time to...

## PHP5 User?

Use the PHP5 Ubuntu 12x | 14x version [nginxubuntu-php5](https://github.com/GaryCornell/nginxubuntu-php5)

## Copyrights

Created by Gary Cornell for devCU Software ©2017
