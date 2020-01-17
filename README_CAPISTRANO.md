# capistrano

## feature
- capistrano deploy
- Circle CI 2.1
- slackistrano
- bastion


## check your version
```
ruby --version && cap -v
```

## show to copy to your project
```
php show-copy-files
```

## to install
```
rm Gemfile.lock && bundle
cp .env.example .env

sudo mkdir -p /opt/www
sudo chown -R ubuntu.ubuntu /opt/www
# sudo chmod -R 755 /opt/www
```

## try to depoly
```
# 手動 deploy 的時候, 是吃 localhost 的 .env & tools/capistrano/ 裡面的設定檔
CI_BRANCH=master cap localhost  deploy --dry-run
CI_BRANCH=master cap staging    deploy --dry-run
CI_BRANCH=master cap production deploy --dry-run
```

## 如果有發生錯誤
- 確認 deploy.rb 設定各種工具的版本, 版本不同將無法正確 deploy
