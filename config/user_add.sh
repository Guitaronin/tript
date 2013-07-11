#!/usr/bin/env sh

sudo /usr/sbin/groupadd admin
sudo /usr/sbin/adduser -G admin tript
sudo /usr/sbin/usermod -a -G wheel tript
# sudo /usr/sbin/usermod -a -G rvm tript
sudo passwd tript
 # 6z9npd7rh9tapz8t

su tript

mkdir -p /home/tript/.ssh
touch /home/tript/.ssh/authorized_keys

auth_keys="/home/tript/.ssh/authorized_keys"
cat >> ${auth_keys} << EOL

EOL

chown -R tript:tript /home/tript/.ssh
chmod 700 /home/tript/.ssh
chmod 600 /home/tript/.ssh/authorized_keys

# AS ROOT
# mv /etc/sudoers /etc/sudoers.bak
# mv /tmp/sudoers /etc/sudoers
# chmod 0440 /etc/sudoers
# chown root:root /etc/sudoers

