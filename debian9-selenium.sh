#! /bin/bash

# This script is prepared for DigitalOcean droplet debian 9
# Credit 0xboz@hacari.com

# Change sources.list
sed -i -e '$ a\apt_preserve_sources_list: true' /etc/cloud/cloud.cfg

# Comment out all lines
sed -i -e 's/^#*/#/' /etc/apt/sources.list

sed -i -e 's/^#*/#/' /etc/cloud/templates/sources.list.debian.tmpl

# Create customSources.list
echo 'deb http://ftp.us.debian.org/debian/ stretch main contrib non-free' >> /etc/apt/sources.list.d/customSources.list

echo 'deb http://security.debian.org/debian-security stretch/updates main contrib non-free' >> /etc/apt/sources.list.d/customSources.list

echo '#deb http://ftp.debian.org/debian stretch-backports main' >> /etc/apt/sources.list.d/customSources.list

apt update && apt -y upgrade && apt -y autoremove

# Obtain IP
IP="$(ifconfig eth0 | grep inet | awk '/[0-9]\./{print $2}')"

# Change hostname
sed -i -e 's/manage_etc_hosts/#manage_etc_hosts/' /etc/cloud/cloud.cfg

sed -i -e 's/.*/Debian9/' /etc/hostname

sed -i -e 's/127\.0\.0\.1.*/127.0.0.1 localhost.localdomain localhost/' /etc/hosts

sed -i -e 's/127\.0\.1\.1.*/127.0.1.1 Debian9.localdomain Debian9/' /etc/hosts

# Custom prompt
echo "export PS1=\"\[\033[40m\]\[\033[32m\]"$IP"\[\033[0m\] \[\033[31m\]\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\u@\h\[\033[0m\]:\w\$ \"" > ~/.bash_profile

source ~/.bash_profile

# Install pip, unzip and virtual display xvfb
apt install -y python3-pip xvfb unzip

pip3 install --upgrade pip

# Install chrome and chrome webdriver
apt install -y libxss1 libappindicator1 libindicator7

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

dpkg -i google-chrome*.deb

apt install -y -f

dpkg -i google-chrome*.deb

wget https://chromedriver.storage.googleapis.com/2.45/chromedriver_linux64.zip

unzip chromedriver_linux64.zip

chmod +x chromedriver

mv -f chromedriver /usr/local/bin/chromedriver

rm chromedriver_linux64.zip google-chrome*.deb

# Install pip packages
# Make sure you upload the requirements.txt under /root/
wget -c https://raw.githubusercontent.com/0xboz/webautoapp/DigitaloceanDebian9Setup/requirements.txt -O requirements.txt
pip install -r requirements.txt

# Download the test file and see if everything works okay
wget -c https://raw.githubusercontent.com/0xboz/webautoapp/DigitaloceanDebian9Setup/do_selenium_test.py -O do_selenium_test.py
chmod +x do_selenium_test.py
./do_selenium_test.py
# It should show something like this
# Breaking News, World News & Multimedia - The New York Times

# Suggest Rebooting
echo "Reboot the machine and finish the setup."
