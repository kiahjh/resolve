# VM setup

# create new user
adduser kiahjh

# grant sudo privileges to kiahjh
usermod -aG sudo kiahjh

ufw allow OpenSSH
ufw enable

# switch to kiahjh
su kiahjh
mkdir ~/.ssh

rsync --archive --chown=kiahjh:kiahjh ~/.ssh /home/kiahjh # copy over authorized keys
exit # exit back to root

# don't ask kiahjh for sudo password:
echo "kiahjh ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

sudo apt install sqlite3

# generate an ssh key to access github
su kiahjh
ssh-keygen -t rsa -C "miciahjohnhenderson@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# set timezone (for cron jobs and stuff)
sudo timedatectl set-timezone America/New_York

# allocate extra swap space (so we don't run out of memory when compiling tokio)
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
sudo sysctl vm.swappiness=10
sudo sysctl vm.vfs_cache_pressure=50
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
echo "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf

# clone repo
git clone git@github.com:kiahjh/resolve.git

# install Rust and Cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env # add cargo to path
sudo apt install build-essential # install gcc toolchain
sudo apt install libssl-dev # not sure if I actually need this one
sudo apt install pkg-config # required for openssl-sys crate on linux

# edit ~/resolve/api/.env

# seed db
cargo install sqlx-cli
touch ~/resolve/api/resolve.db
cd ~/resolve/api
sqlx migrate run

# build api
cd ~/resolve/api
cargo build --release # takes a hot minute

# install and configure nginx
sudo apt install nginx
sudo vim /etc/nginx/sites-available/api.resolveapp.net.conf

# paste in the following:
# -------
server {
    listen 80;
    server_name api.resolveapp.net;

    location / {
        proxy_pass http://localhost:4000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
# -------

sudo ln -s /etc/nginx/sites-available/api.resolveapp.net.conf /etc/nginx/sites-enabled/
sudo nginx -t # test nginx config
sudo systemctl restart nginx
sudo ufw allow 'Nginx Full' # <- this is important

# set up daemon with systemctl
sudo vim /etc/systemd/system/resolve-api.service

# paste in the following:
# -------
[Unit]
Description=Resolve API
After=network.target

[Service]
ExecStart=/home/kiahjh/resolve/api/target/release/api
WorkingDirectory=/home/kiahjh/resolve/api
Restart=always
User=root

[Install]
WantedBy=multi-user.target
# -------

sudo systemctl daemon-reload
sudo systemctl start resolve-api.service
sudo systemctl enable resolve-api.service
sudo systemctl status resolve-api.service # check status
sudo journalctl -u resolve-api.service # check logs
# manage it with stop/start/restart/status

# install certbot
sudo apt update
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d api.resolveapp.net -d www.api.resolveapp.net
