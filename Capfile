# Load DSL and set up stages
require 'capistrano/setup'
# Include default deployment tasks
require 'capistrano/deploy'
# Include tasks from other gems included in your Gemfile
require 'capistrano/rbenv'
require 'capistrano/rbenv_install'
require 'capistrano/bundler'
require 'capistrano/rails'
# Nginx Web Server
require 'capistrano/nginx'
# PUMA Application Server
require 'capistrano/puma'
require 'capistrano/puma/nginx'
# Capistrano Utils
require 'capistrano/ssh_doctor'
require 'capistrano/upload-config'
require 'capistrano/rbenv_vars'
require 'capistrano/rails/console'
require 'capistrano/rails_tail_log'
require 'capistrano/rails/collection'
# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
