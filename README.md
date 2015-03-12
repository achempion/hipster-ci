[![Code Climate](https://codeclimate.com/github/achempion/hipster-ci/badges/gpa.svg)](https://codeclimate.com/github/achempion/hipster-ci)

## Hipster CI
![Hipster CI](https://www.evernote.com/shard/s233/sh/a408c476-00d8-49bc-93a9-a02c4940586a/1af097048d96ee925b09e2df8abd3403/res/a51afa2c-905d-441c-84ac-07420ca67733/skitch.png)
![Hipster CI](https://www.evernote.com/shard/s233/sh/9e0e5b55-63d4-4f6e-8f3d-53be5716bb9c/a99f1d028aa85ceb5cfcba3478cf32bf/res/f75b279d-7bd5-4d0a-b31f-f4bf6c2473f7/skitch.png)
### What this project do

  - simple CI server for ruby projects hosted on GitHub

### About permissions

  You should create an access github token for getting access to your codebase from CI server
  
  **Settings** > **Applications** > **Generate new token**
  and then select the first check box called "repo"
  
### Project configuration

  1. at `/ config / application.rb`, paste your github access token to `default_project_access_token` option
  
  2. configure your login and password at `/ config / environments / production.rb`
  
  3. define bash `SECRET_KEY_BASE` environment variable with result of `rake secret` command
  
### Running

  With `production` environment
  
  ```
$ bundle
$ rake db:schema:load
$ rake assets:precompile
$ rails s -p 80 &
$ rake scheduler:perform &
  ```
  
### How to notificate CI server for new commits
  
  - Go to your project at github.com
  - Settins > Webhooks & Services > Add webhook
  - enter Payload URL
  - click Add Webhook
  
  **Payload URL**

  `http://[login_from_production.rb]:[password_from_production.rb]@[ci_server_address]/triggers/github`
  
  example:
  
  `http://admin:secret@example.com/triggers/github`
  
  That's all!
  
### Customization
  
  Touch `config / hipster_ci.yml` in your project with content:
  
  ```yaml
requirements:
  - xfvb
  - curl

spec_command: xvfb-run rspec

database: mysql
  ```
  
`requirements` — libs that will be installed with `apt-get` command

`spec_command` — command that will replace default `rspec / spec` command

 `database` — custom database for build, `sqlite` by default and available values is `sqlite` and `mysql`

### License

Hipster CI is released under the [MIT License](http://www.opensource.org/licenses/MIT).
