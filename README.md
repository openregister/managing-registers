# Manage your Register

This is the service used primarily by register custodians to manage their registers. You can find out more information about registers or contact us [here](https://registers.cloudapps.digital/).

### 1. Prerequisites
Ruby 2.4

### 2. Create database, migrate tables and seed user data
`rake db:setup`

### 3. Load Country Data
`rails runner "FetchCountriesFromCountryRegisterJob.perform_now"`

### 4. Run the application
`rails s`

### 5 Run further migrations of the Database
`rake db:migrate`
