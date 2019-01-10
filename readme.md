#### install
```
bundle
cp .env.example .env
```

#### try
```
CI_BRANCH=master cap localhost  deploy --dry-run
CI_BRANCH=master cap production deploy --dry-run
```