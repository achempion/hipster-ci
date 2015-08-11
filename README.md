[![Code Climate](https://codeclimate.com/github/achempion/hipster-ci/badges/gpa.svg)](https://codeclimate.com/github/achempion/hipster-ci)

## Hipster CI

  The main documentation at http://hipster-ci.com
  
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

 `database` — custom database for build, `sqlite` by default and available values is `sqlite`, `mysql` and `postgres`

### License

Hipster CI is released under the [MIT License](http://www.opensource.org/licenses/MIT).
