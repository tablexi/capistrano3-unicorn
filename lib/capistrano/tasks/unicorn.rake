namespace :unicorn do
  desc 'Reload Unicorn (HUP); use this when preload_app: false'
  task :reload do
    invoke 'unicorn:start'
    on roles(:app) do
      within release_path do
        info "reloading..."
        execute :kill, "-s HUP", pid
      end
    end
  end

  desc 'Restart Unicorn (USR2 + QUIT); use this when preload_app: true'
  task :restart do
    invoke 'unicorn:start'
    on roles(:app) do
      within release_path do
        info "unicorn restarting..."
        execute :kill, "-s USR2", pid
        sleep 1
        execute :kill, "-s QUIT", pid_oldbin
      end
    end
  end

  desc 'Start Unicorn'
  task :start do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          if test("[ -e #{pidfile} ] && kill -0 #{pid}")
            info "unicorn is running..."
          else
            execute :bundle, "exec unicorn", "-c", unicorn_config_path(current_path), "-E", fetch(:rails_env), "-D"
          end
        end
      end
    end
  end

  desc 'Stop Unicorn (QUIT)'
  task :stop do
    on roles(:app) do
      within release_path do
        if test("[ -e #{pidfile} ] && kill -0 #{pid}")
          info "stopping unicorn..."
          execute :kill, "-s QUIT", pid
          execute :rm, pidfile
        else
          info "unicorn is not running..."
        end
      end
    end
  end

  desc 'Add a worker (TTIN)'
  task :add_worker do
    on roles(:app) do
      within release_path do
        execute :kill, "-s TTIN", pid
      end
    end
  end

  desc 'Remove a worker (TTOU)'
  task :remove_worker do
    on roles(:app) do
      within release_path do
        execute :kill, "-s TTOU", pid
      end
    end
  end
end

def unicorn_config_path(current_path)
  File.join(current_path, "config", "unicorn", "#{fetch(:rails_env)}.rb")
end

def pid
  "`cat #{pidfile}`"
end

def pidfile
  File.join(shared_path, "pids", "unicorn.pid")
end

def oldpid
  capture("cat #{pidfile_oldbin}")
end

def pidfile_oldbin
  pidfile + ".oldbin"
end
