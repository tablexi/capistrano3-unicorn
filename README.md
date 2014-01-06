# Capistrano3 Unicorn

This is a capistrano v3 plugin that integrates Unicorn tasks into capistrano deployment scripts; it was heavily inspired by [sosedoff/capistrano-unicorn](https://github.com/sosedoff/capistrano-unicorn) but written from scratch to use the capistrano 3 syntax.

### Gotchas

- The `unicorn:start` task invokes unicorn as `bundle exec unicorn`.

- When running tasks not during a full deployment, you may need to run the `rvm:hook`:

    `cap production rvm:hook unicorn:start`

### Conventions

You can override the defaults by `set :unicorn_example, value` in the `config/deploy.rb` or `config/deploy/ENVIRONMENT.rb` capistrano deployment files

- `:unicorn_pid`

    Assumes your pid file will be located in the application's shared path `.../shared/pids/unicorn.pid` so that it survives zero-downtime re-deployments

- `:unicorn_config_path`

    Assumes that your Unicorn configuration will be located in `config/unicorn/RAILS_ENV.rb`

- `:unicorn_restart_sleep_time`

    When performing zero-downtime deployment via the `unicorn:restart` task, send the USR2 signal, sleep for this many seconds (defaults to 3), then send the QUIT signal

- `:unicorn_roles`

    Roles to run unicorn commands on. Defaults to :app

- `:unicorn_options`

    Set any additional options to be passed to unicorn on startup. Defaults to none

- `:unicorn_rack_env`

    Set the RACK_ENV. Defaults to deployment unless the RAILS_ENV is development. Valid options are "development", "deployment", or "none". See the [RACK ENVIRONMENT](http://unicorn.bogomips.org/unicorn_1.html) section of the unicorn documentation for more information.

### Setup

Add the library to your `Gemfile`:

```ruby
group :development do
  gem 'capistrano3-unicorn'
end
```

Add the library to your `Capfile`:

```ruby
require 'capistrano3/unicorn'
```

Invoke Unicorn from your `config/deploy.rb` or `config/deploy/ENVIRONMENT.rb`:

If `preload_app:true` use:

```ruby
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end
```

Otherwise use:

```ruby
namespace :deploy do
  task :restart do
    invoke 'unicorn:reload'
  end
end
```
