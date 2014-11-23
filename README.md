## Hipster CI

### What this project do

  - provide web interface with your projects, builds (each commit is a build) and result of tests
  - run project's tests
  - write comment on github commit page with result of runned tests

### About permissions

  For work with GitHub features like comments or git pull you should generate an access token.
  
  **Settings** > **Applications** > **Generate new token**
  and then select the first check box called "repo"
  
### Project configuration

  For configure this rails project you could write a few lines
  
  at `/ config / application.rb`, option *default_project_access_token* your should provide
  default access token of your github account because you may not want enter it on each new project creation
  
  next configure your login and password at `/ config / environments / production.rb`
  
### Running

  With production environment
  
  ```
$ bundle
$ rake db:migrate
$ rake assets:precompile
$ rails s -p 80 &
$ rake scheduler:perform &
  ```
  
  At this step you can add first project, after this let's configure github webhooks

  - Go to your project page at github.com
  - Settins > Webhooks & Services > Add webhook
  - enter Payload URL
  - click Add Webhook
  
  **Payload URL**

  `http://[login_from_production.rb]:[password_from_production.rb]@[your_webserver_address.com]/triggers/github`
  
  example:
  
  `http://admin:secret@example.com/triggers/github`
  
  That's all
  
### How to run project tests with any other command or define system requirements

  For example: You add a project to Hipster CI and project has a requirements, like mysqlclient-dev or imagemagic or something else
  
  Just create a configuration file at `config / hipster_ci.yml`, with content like 
  
  ```yaml
requirements:
  - xfvb
  - curl

spec_command: xvfb-run rspec

database: mysql
  ```
  
`requirements` — libs that will be installed with `apt-get` command
`spec_command` — command that replaced standart `rspec / spec` command
 `database` — custom database for build, `sqlite` by default and available values is `sqlite` and `mysql`

### License

Hipster CI is released under the [MIT License](http://www.opensource.org/licenses/MIT).
