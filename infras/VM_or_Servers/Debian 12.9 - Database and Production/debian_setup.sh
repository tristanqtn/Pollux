sudo apt upda

# if you wanna upgrade all the packages installed (not our case), remove # below
# sudo apt upgrade -y 

# Services installation
sudo apt install -y openssh-server nginx mongodb-org kibana elasticsearch

# SFTP configuration
sudo sed -i '/Subsystem sftp/c\Subsystem sftp /usr/lib/openssh/sftp-server' /etc/ssh/sshd_config


# Add APT directory for MongoDB (if not already done)
if ! grep -q "https://repo.mongodb.org/apt/debian" /etc/apt/sources.list.d/mongodb-org-6.0.list 2>/dev/null; then
    wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/debian buster/mongodb-org/6.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
    sudo apt update
fi

# SophosAV installation
SOPHOS_INSTALLER_URL="https://downloads.sophos.com/endpoint/sophos-av-linux.tgz"
INSTALL_DIR="/tmp/sophos_av"
mkdir -p $INSTALL_DIR
wget -qO $INSTALL_DIR/sophos-av-linux.tgz "$SOPHOS_INSTALLER_URL"
tar -xzf $INSTALL_DIR/sophos-av-linux.tgz -C $INSTALL_DIR
sudo bash $INSTALL_DIR/sophos-av/install.sh


# Firewall installation
sudo apt install -y firewalld

# Firewall initialization
sudo systemctl enable firewalld
sudo systemctl start firewalld

# Port opening
sudo firewall-cmd --permanent --add-port=22/tcp #SSH
sudo firewall-cmd --permanent --add-port=80/tcp #HTTP
sudo firewall-cmd --permanent --add-port=443/tcp #HTTPS
sudo firewall-cmd --permanent --add-port=990/tcp #SFTP
sudo firewall-cmd --permanent --add-port=5601/tcp #Kibana
sudo firewall-cmd --permanent --add-port=9200/tcp #ElasticSearch
sudo firewall-cmd --permanent --add-port=27017/tcp #MongoDB


# General rules (firewalld zones)
sudo firewall-cmd --set-default-zone=drop
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" state="ESTABLISHED,RELATED" accept'


# Restarting services
sudo firewall-cmd --reload
sudo systemctl restart ssh # same service for ssh and sftp
sudo systemctl restart nginx
sudo systemctl restart mongod
sudo systemctl restart kibana
sudo systemctl restart elasticsearch

# Services status check
for service in ssh nginx mongod kibana elasticsearch firewalld; do
    echo "Statut de $service :"
	sudo systemctl enable $service
	sudo systemctl start $service
    sudo systemctl status $service --no-pager
done

echo "Configuration is complete"