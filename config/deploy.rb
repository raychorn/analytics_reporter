set :application, "analytics_reporter"
set :repository, "https://build@eng.mxplay.com/repos/main/analytics/trunk/analytics_reporter"
set :use_sudo, false
set(:deploy_to) { "/var/www/#{application}" }
set :user, "deploy"
set :deploy_via, :remote_cache
set :copy_exclude, [".svn"]
set :keep_releases, 2 # for deploy:cleanup

task :production do
  set :application, "analytics_reporter"
  set :hive1, "10.100.162.61" #"198.177.231.61"#Private "10.100.162.61"
  role :app, hive1
  role :web, hive1
  set :analytics_sudo_user, "cloud"
end

task :staging do
  set :application, "analytics_reporter"
  set :hivedev, "10.100.162.51"#Public "198.177.231.51"
  role :app, hivedev
  role :web, hivedev
  set :analytics_sudo_user, "cftuser"
end

task :video do
  set :application, "analytics_reporter"
  set :videodev, "192.168.62.4"
  role :app, videodev
  role :web, videodev
  set :analytics_sudo_user, "cloud"
end

after "deploy", "deploy:cleanup"

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

namespace :apache do
  desc "update apache per-app conf files, uploading local copies"
  task :update, :roles => :app do
    local_repo_config_path = "config/sites/apache2/sites-available/#{application}.conf"
    remote_repo_config_folder = "#{deploy_to}/current/config/sites/apache2/sites-available"
    remote_repo_config_path = "#{remote_repo_config_folder}/#{application}.conf"

    logger.info "uploading custom config"
    upload(local_repo_config_path, remote_repo_config_path, :via => :scp)

    with_user(analytics_sudo_user) do
      run "#{sudo} rm -rf /etc/apache2/sites-enabled/#{application}.conf"
      run "#{sudo} cp #{remote_repo_config_path} /etc/apache2/sites-available/#{application}.conf"
      run "#{sudo} ln -s ../sites-available/#{application}.conf /etc/apache2/sites-enabled/#{application}.conf"
    end
  end

  desc "update apache root conf files, uploading local copies"
  task :update_root_conf, :roles => :app do
    upload("config/sites/apache2/ports.conf", "#{deploy_to}/current/config/sites/apache2/ports.conf", :via => :scp)
    upload("config/sites/apache2/mods-available/passenger.conf", "#{deploy_to}/current/config/sites/apache2/mods-available/passenger.conf", :via => :scp)

    with_user(analytics_sudo_user) do
      run "#{sudo} cp #{deploy_to}/current/config/sites/apache2/ports.conf /etc/apache2/ports.conf"
      run "#{sudo} cp #{deploy_to}/current/config/sites/apache2/mods-available/passenger.conf /etc/apache2/mods-available/passenger.conf"
      run "#{sudo} rm -rf /etc/apache2/mods-enabled/passenger.conf"
      run "#{sudo} ln -s ../mods-available/passenger.conf /etc/apache2/mods-enabled/passenger.conf"
    end
  end

  %w(start stop restart).each do |action|
    desc "#{action} Apache"
    task action.to_sym, :roles => :app do
      with_user(analytics_sudo_user) do
        run "#{sudo} apache2ctl #{action}"
      end
    end
  end
end

# TODO: should take in a password or clear password
def with_user(new_user, &block)
  old_user = user
  set :user, new_user
  close_sessions
  yield
  set :user, old_user
  close_sessions
end

def close_sessions
  sessions.values.each { |session| session.close }
  sessions.clear
end