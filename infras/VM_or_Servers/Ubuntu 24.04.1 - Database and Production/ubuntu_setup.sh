sudo apt upda

# if you wanna upgrade all the packages installed (not our case), remove # below
# sudo apt upgrade -y 

# Services installation
sudo apt install -y openssh-server xrdp mariadb-server apache2 vsftpd clamav

# Firewall installation (if not already done)
sudo apt install -y iptables

# Port opening
sudo iptables -A INPUT -p tcp --dport 21 -j ACCEPT #FTP
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT #SSH
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT #HTTP
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT #HTTPS
sudo iptables -A INPUT -p tcp --dport 3306 -j ACCEPT #MySQL
sudo iptables -A INPUT -p tcp --dport 3389 -j ACCEPT #FTP

# General rules
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT # Existing connexions
sudo iptables -P INPUT DROP # Drop all incoming packets
sudo iptables -P FORWARD DROP # Drop all forwarded packets
sudo iptables -P OUTPUT ACCEPT # Accept all outgoing packets

# Saving iptables rules
sudo apt install -y iptables-persistent
sudo netfilter-persistent save
sudo netfilter-persistent reload

# Restarting services
sudo systemctl restart ssh
sudo systemctl restart xrdp
sudo systemctl restart mariadb
sudo systemctl restart apache2
sudo systemctl restart vsftpd

# ClamAV database update
sudo freshclam

# Services status check
for service in ssh xrdp mariadb apache2 vsftpd; do
    echo "Statut de $service :"
    sudo systemctl status $service --no-pager
done

echo "Configuration is complete"
