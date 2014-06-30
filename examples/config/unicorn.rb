# ------------------------------------------------------------------------------
# Sample unicorn config
# ------------------------------------------------------------------------------

# Set your full path to application.
app_path = "/path/to/app"

# Set unicorn options
worker_processes 1
preload_app true
timeout 180
listen "127.0.0.1:9000"

# Spawn unicorn master worker for user apps (group: apps)
user 'apps', 'apps'

# Fill path to your app
working_directory app_path
pid "#{app_path}/tmp/pids/unicorn.pid"

# 'production' by default, otherwise use supplied rails env
rails_env = ENV['RAILS_ENV'] || 'production'

# Log everything to one file
stderr_path "log/unicorn.log"
stdout_path "log/unicorn.log"

# Set master PID location
pid "#{app_path}/tmp/pids/unicorn.pid"

before_fork do |server, worker|
  # there's no need for the master process to hold a connection
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  # kill the old unicorn process if it exists
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
