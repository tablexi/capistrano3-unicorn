# Capistrano3 Unicorn Changelog

## `0.2.1`

- Revert `:unicorn_config_path` falling back to `config/unicorn/unicorn.rb` due to flawed implementation

## `0.2.0`

- `unicorn:restart` no longer sends QUIT to oldbin since most people use a callback in `unicorn.rb`
- `unicorn:legacy_restart` preserves the QUIT to oldbin
- `:unicorn_config_path` adds `config/unicorn/unicorn.rb` as a default path
- added example unicorn.rb
- removed `:unicorn_bundle_gemfile`, this should have been in a before_exec in the unicorn configuration

Thanks to @spectator, @lxxdn, @ahorner, and @soulcutter

## `0.1.1`

- Removed default value for `:unicorn_bundle_gemfile` of `:bundle_gemfile` so that current_path is the default

## `0.1.0`

- Changed default location of `:unicorn_pid`
- Depend on capistrano => 3.1.0
- Added `:unicorn_bundle_gemfile` to override `:bundle_gemfile`
- Bugfix; use current_path vs release_path

Thanks to @eLod, @mbrictson, and @complistic-gaff

## `0.0.6`

- Buxfix; unicorn -E should be passed a RACK_ENV (not a RAILS_ENV). [More here](http://www.hezmatt.org/~mpalmer/blog/2013/10/13/rack_env-its-not-for-you)

## `0.0.5`

- Added `:unicorn_options`

## `0.0.4`

- Added `:unicorn_roles`
