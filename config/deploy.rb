# config valid only for current version of Capistrano
lock '3.4.0'
set :application, 'techblog'
set :repo_url, "git@github.com:[username]/#{fetch(:application)}.git"
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
# Default deploy_to directory is /var/www/my_app_name
set :user, 'deployer'
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :deploy_via,      :remote_cache
set :puma_threads,    [4, 16]
set :puma_workers,    0
# Don't change these unless you know what you're doing
# set :pty,             true
# set :use_sudo,        false
# set :stage,           :production
# set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
# set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
# set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
# set :puma_access_log, "#{release_path}/log/puma.error.log"
# set :puma_error_log,  "#{release_path}/log/puma.access.log"
# set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
# set :puma_preload_app, true
# set :puma_worker_timeout, nil
# set :puma_init_active_record, true  # Change to false when not using ActiveRecord
# RBENV and RUBY
set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value
# Default value for :log_level is :debug
# set :log_level, :debug
# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', '.rbenv-vars')
# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
# Default value for keep_releases is 5
# set :keep_releases, 5
before 'deploy:check:linked_files', 'config:push'
namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end
  before :start, :make_dirs
end
namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end
  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'puma:start', 'puma:nginx_config'
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end
  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end
# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma
