namespace :unicorn do
  desc 'Reload Unicorn (HUP); use this when preload_app: false'
  task :reload do
    on roles(:app) do
      within release_path do
        execute :kill, "-s HUP", pid(shared_path)
      end
    end
  end

  desc 'Restart Unicorn (USR2 + QUIT); use this when preload_app: true'
  task :restart do
    on roles(:app) do
      within release_path do
        execute :kill, "-s USR2", pid(shared_path)
        sleep 1
        execute :kill, "-s QUIT", pid_oldbin(shared_path)
      end
    end
  end

  desc 'Start Unicorn'
  task :start do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          #execute :unicorn, "-c", unicorn_config_path(current_path), "-E", fetch(:rails_env), "-D"
          execute :bundle, "exec unicorn", "-c", unicorn_config_path(current_path), "-E", fetch(:rails_env), "-D"
        end
      end
    end
  end

  desc 'Stop Unicorn (QUIT)'
  task :stop do
    on roles(:app) do
      within release_path do
        execute :kill, "-s QUIT", pid(shared_path)
      end
    end
  end

  desc 'Add a worker (TTIN)'
  task :add_worker do
    on roles(:app) do
      within release_path do
        execute :kill, "-s TTIN", pid(shared_path)
      end
    end
  end

  desc 'Remove a worker (TTOU)'
  task :remove_worker do
    on roles(:app) do
      within release_path do
        execute :kill, "-s TTOU", pid(shared_path)
      end
    end
  end
end

def unicorn_config_path(current_path)
  File.join(current_path, "config", "unicorn", "#{fetch(:rails_env)}.rb")
end

def pid(shared_path)
  capture("cat #{pidfile(shared_path)}")
end

def pidfile(shared_path)
  File.join(shared_path, "pids", "unicorn.pid")
end

def oldpid(shared_path)
  capture("cat #{pidfile_oldbin(shared_path)}")
end

def pidfile_oldbin(shared_path)
  pidfile(shared_path) + ".oldbin"
end
