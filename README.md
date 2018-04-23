# Manage your Register

This is the service used primarily by register custodians to manage their registers. You can find out more information about registers or contact us [here](https://registers.cloudapps.digital/).

## Running locally

### 1. Prerequisites
Ruby 2.4.3
Postgres 9.5+

### 2. Install Gems
`bundle install`

### 3. Set Rails master key environment variable
```
export RAILS_MASTER_KEY=`registers-pass show registers/app/manager/store`
```

### 4. Create database, migrate tables and seed user data
`rake db:setup`

### 5. Run the application
`rails s`

### 6 Run further migrations of the Database
`rake db:migrate`

## Deployment
`managing-registers` uses continuous deployment, all code pushed to the `master` branch will be automatically deployment to production.
### Testing your changes
You have two options if you wish to test your changes on the staging environment:
1. Push your code to the `staging` branch which will be automatically deployed to the `staging` environment *or*
1. Deploy your branch locally by installing [autopilot](https://github.com/contraband/autopilot) then running: 
``` 
cf target -s sandbox
cf zero-downtime-push managing-registers -f manifest-staging.yml
```


## License

Unless stated otherwise, this codebase is released under [the MIT
license](./LICENSE).
