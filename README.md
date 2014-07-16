# Capistrano3 Unicorn

This is a capistrano v3 plugin that integrates Unicorn tasks into capistrano deployment scripts; it was heavily inspired by [sosedoff/capistrano-unicorn](https://github.com/sosedoff/capistrano-unicorn) but written from scratch to use the capistrano 3 syntax.

### Gotchas

- The `unicorn:start` task invokes unicorn as `bundle exec unicorn`.

- When running tasks not during a full deployment, you may need to run the `rvm:hook`:

    `cap production rvm:hook unicorn:start`

### Conventions

You can override the defaults by `set :unicorn_example, value` in the `config/deploy.rb` or `config/deploy/ENVIRONMENT.rb` capistrano deployment files.

Example Unicorn config [examples/unicorn.rb](https://github.com/tablexi/capistrano3-unicorn/blob/master/examples/unicorn.rb)

- `:unicorn_pid`

    Default assumes your pid file will be located in `CURRENT_PATH/tmp/pids/unicorn.pid`. The unicorn_pid should be defined with an absolute path.

- `:unicorn_config_path`

    Default assumes that your Unicorn configuration will be located in `CURRENT_PATH/config/unicorn/RAILS_ENV.rb`

- `:unicorn_roles`

    Roles to run unicorn commands on. Defaults to :app

- `:unicorn_options`

    Set any additional options to be passed to unicorn on startup. Defaults to none

- `:unicorn_rack_env`

    Set the RACK_ENV. Defaults to deployment unless the RAILS_ENV is development. Valid options are "development", "deployment", or "none". See the [RACK ENVIRONMENT](http://unicorn.bogomips.org/unicorn_1.html) section of the unicorn documentation for more information.

- `:unicorn_bundle_gemfile`

    ***REMOVED in v0.2.0***

    Set the BUNDLE_GEMFILE in a before_exec block in your unicorn.rb. See [sandbox](http://unicorn.bogomips.org/Sandbox.html) and [unicorn-restart-issue-with-capistrano](https://stackoverflow.com/questions/8330577/unicorn-restart-issue-with-capistrano)

- `:unicorn_restart_sleep_time`

    In `unicorn:legacy_restart` send the USR2 signal, sleep for this many seconds (defaults to 3), then send the QUIT signal

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
after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end
```

If `preload_app:true` and you need capistrano to cleanup your oldbin pid use:

```ruby
after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:legacy_restart'
  end
end
```

Otherwise use:

```ruby
after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:reload'
  end
end
```

Note that presently you must put the `invoke` outside any `on` block since the task handles this for you; otherwise you will get an `undefined method 'verbosity'` error.
