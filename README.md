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
        \\ \ \ \|     Nginx Ubuntu 2.02    |/ / / //
         `'-\_\_\       Setup Script       /_/_/-'`
                '--------------------------'
</pre>

A bash script that automates Nginx, PHP5x,  PHP-FPM and User/Domain setup in a couple minutes. For NEW/Fresh server installs but can be used to setup-add new user/domain and directory structure anytime

Created for Ubuntu 16x Servers but should work on all Debian flavors that support PHP7 - Please Read Comments in Code for Proper or custom Configuration

Uses a standard $HOME/$USER/public_html directory setup but can be edited for any type directory structure

## Optional

- Runs a apt-get update/upgrade if applicable

- Optional install latest mainline Nginx (recommended)

- Optional update to latest Linux Kernel (recommended)

- Optional PHP5 install w/dependencies

- Optional php.ini secured (recommended)

- Optional Generates 2048 Diffie-Hellman for TLS (recommended)(OpenSSL required)

- Editable options see below

## Functions

- Setup/Create Nginx directory structure, sites available/enabled/domain.vhost conf

- Updates cgi.fix_pathinfo=0 in fpm and cli php.ini

- Setup/Create php-fpm directory structure, domain.conf

- Setup/Create user/pass with domain/IP and public_html directory structure

- Sets all proper permissions on relevant directories.

- Adds index.php skel to directory


### Creates the following $HOME directory structure

- $HOME
    - $USER
        - _sessions
        - backups
        - logs
        - public_html
               - index.php
        - ssl
        
        
## Editable

See [/src/auto_create_web.sh](https://github.com/GaryCornell/nginxubuntu-php7/blob/master/src/auto_create_web.sh) for editable fields

## Simple Usage as root

1. cd /opt  (Any directory you choose is fine)

2. wget https://github.com/GaryCornell/nginxubuntu-php7/archive/2.02.tar.gz

3. tar -xvzf nginxubuntu_v202.tar.gz

4. cd nginxubuntu

5. chmod u+x auto_create_web.sh

6. ./auto_create_web.sh yourdomain.com

7. Just follow the prompts

8. Edit domain.vhost accordingly. The vhost is updated with the latest security features for SSL if using a cert you must uncomment and make sure paths are correct. The script sets up the standard path $HOME/$USER/ssl to cert/key/trusted_chain.pem but of course you must supply the files. root path/logs path/php-fpm unix socket and sessions paths are setup and work out of the box for you but can be edited for custom paths.

## License

Apache License 2.0

## Development

Created in 2016 and updated last in Jan 2017. Some further development is planned but any serious functionality issues or security issues will be addressed if discovered by me or reported by users.

## PHP5 User?

Use the PHP5 Ubuntu 12x | 14x version [nginxubuntu-php5](https://github.com/GaryCornell/nginxubuntu-php5)
