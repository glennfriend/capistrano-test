# config valid only for current version of Capistrano
Dotenv.overload ".env.#{fetch(:stage)}", '.env' # override system env


# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# config/deploy.rb
# config valid only for current version of Capistrano
lock '~>3.11.0'


#
set :application,   ENV['APPLICATION']
set :app_env,       ENV['APP_ENV']
set :repo_url,      ENV['REPO']
set :deploy_to,     nil     # convert by states/*.rb
set :php_bin_path,  "$HOME/.phpbrew/php/php-#{ENV['PHP_VERSION']}/bin"
set :exec_phpbrew,  "source ~/.phpbrew/bashrc && phpbrew use #{ENV['PHP_VERSION']}"
set :exec_nvm,      "source ~/.nvm/nvm.sh && nvm use #{ENV['NODE_VERSION']}"


# basic settings
set :scm, :git
set :format, :airbrussh   # :pretty
set :log_level, :debug
set :pty, true
set :keep_releases, 5
set :linked_dirs, %w{storage node_modules}  # please not link "vendor" folder
set :linked_files, %w{.env}
set :default_env, {
  path: "#{fetch(:php_bin_path)}:/opt/ruby/bin:$PATH"
}


# laravel setting
set :laravel_working_dir, "./"
set :laravel_dotenv_file, '' # do not copy local .env to the server
set :laravel_version, 5.7
set :laravel_upload_dotenv_file_on_deploy, false
set :laravel_artisan_flags, "--env=production"
set :laravel_set_linked_dirs, false
set :laravel_set_acl_paths, true
set :laravel_server_user, "www-data"
set :composer_working_dir, -> { "#{fetch(:release_path)}" }
set :composer_install_flags, ''


# yarn setting
set :yarn_flags, '--silent'
set :yarn_roles, :all
set :yarn_env_variables, {}


# nvm settings
set :nvm_type, :user # or :system, depends on your nvm setup
set :nvm_node, "v#{ENV['NODE_VERSION']}"
set :nvm_map_bins, %w{node yarn pm2}
set :nvm_node_path, -> {
  if fetch(:nvm_type, :user) == :system
    '/usr/local/nvm/'
  else
    "$HOME/.nvm/"
  end
}


# bastion setting
if ENV['VIA_BASTION']
  # Use a default host for the bastion, but allow it to be overridden
  bastion_host = ENV['BASTION_HOST'] || 'your-proxy-server.example.com'

  # Use the local username by default
  bastion_user = ENV['BASTION_USER'] || ENV['USER']

  # Configure Capistrano to use the bastion host as a proxy
  set :ssh_proxy, Net::SSH::Proxy::Jump.new("#{bastion_user}@#{bastion_host}")
end


# pm2 settings
# set :pm2_config, 'tools/pm2/pm2.config.js --update-env' # PM2 config path by default
# namespace :deploy do
#   # hooks
#   after :updated, 'build:prod'
#   after :published, 'pm2:reload'
#   after :published, 'pm2:dump'
#   after :finishing, 'pm2:reset'
# end




### ============================================================
namespace :deploy do

  # 當 current 目錄不存在時, 先不要開啟
  # after 'deploy:starting', :task do
  #   on release_roles :all do
  #     within "#{current_path}" do   # in current_path folder
  #       execute 'pwd'
  #       puts "         ========== #{fetch(:app_env)} =========="
  #       puts
  #       puts "         default_env  : #{fetch(:default_env)}"
  #       puts "         branch       : #{fetch(:branch)}"
  #       puts "         deploy_to    : #{fetch(:deploy_to)}"
  #       puts "         path         : #{:pwd}"
  #       puts
  #     end
  #   end
  # end

  after "deploy:updated", :laravel_tasks do
    invoke "laravel:migrate", :'--force'
  end

  after 'composer:install', "composer:update_composer"
end
