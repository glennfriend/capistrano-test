## developer 用的資訊顯示工具


#### install
```
composer config "repositories.private-info" path "packages/Cor/PrivateInfo"
composer require --dev "cor/private-info:dev-master"
```

#### install options
```
php artisan vendor:publish --provider="Cor\PrivateInfoServiceProvider"
```

### remove the package
```
composer remove "cor/private-info"
```


#### 注意
- 該程式未使用 Auth, 使用的是 ip check 的方式
- 有使用 Provider, 所以如果要改變 ip 的認証內容, 可以復製 config 來使用