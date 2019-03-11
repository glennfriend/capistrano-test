#### install
```
bundle
cp .env.example .env

sudo mkdir -p /opt/www
sudo chown -R ubuntu.ubuntu /opt/www
# sudo chmod -R 755 /opt/www
```

#### try
```
CI_BRANCH=master cap localhost  deploy --dry-run
CI_BRANCH=master cap production deploy --dry-run
```