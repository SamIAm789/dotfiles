## Enable zram

Debian host
```
sudo apt update
sudo apt install zram-tools
sudo systemctl enable --now zramswap
```

## Create a swap file
```
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```


