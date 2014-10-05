## Hipster CI

### What this project do

  - provide web interface with your projects, builds (each commit is a build) and result of specs
  - write comment on github commit page with result of runned specs

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

  It's all, just `bundle` and `rake db:migrate` and then `rails s -e production &`
  
  Don't forget run your spec daemon with `rake scheduler:perform &`
