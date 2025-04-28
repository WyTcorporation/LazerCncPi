sudo apt update
sudo apt full-upgrade -y
sudo reboot

sudo apt install git build-essential curl -y
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install nodejs -y
sudo apt-get install npm

# Перевірка Node.js
node -v && npm -v

# Встановлюємо CNC.js
sudo npm install -g cncjs

Автозапуск CNC.js при старті Raspberry Pi:
sudo npm install pm2@latest -g
pm2 startup systemd
pm2 start $(which cncjs) -- --port 8080
pm2 save

