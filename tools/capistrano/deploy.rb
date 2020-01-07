# config valid only for current version of Capistrano

set :application,   ENV['APPLICATION']    # my-app
set :repo_url,      ENV['REPO']           # git@github.com:your_github_account/project-name.git
set :deploy_to,     ENV['DEPLOY_TO']      # /var/www/my-app

set :php_bin_path,  "$HOME/.phpbrew/php/php-#{ENV['PHP_VERSION']}/bin"
set :exec_phpbrew,  "source $HOME/.phpbrew/bashrc && phpbrew use #{ENV['PHP_VERSION']}"
set :exec_nvm,      "source $HOME/.nvm/nvm.sh     && nvm use #{ENV['NODE_VERSION']}"

lock '3.6.0'
# 請嘗試 => lock '3.11.0'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{.env}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
set :default_env, {
  path: "#{fetch(:php_bin_path)}:$PATH"
  # path: "#{fetch(:php_bin_path)}:/opt/ruby/bin:$PATH"
}

set :linked_dirs, %w{storage node_modules}

# /opt/www/xxxxxx/releases 最多留下多少個版本?
set :keep_releases, 5

###
set :composer_working_dir, -> { "#{fetch(:release_path)}" }
set :composer_install_flags, ''

###
set :laravel_working_dir, "./"
set :laravel_dotenv_file, ".env"  # do not copy local .env to the server
set :laravel_version, 5.7
set :laravel_artisan_flags, "--env=production"
set :laravel_set_linked_dirs, false
set :laravel_set_acl_paths, true
set :laravel_server_user, "www-data"




# nvm settings
set :nvm_type, :user # or :system, depends on your nvm setup
set :nvm_node, "v#{ENV['NODE_VERSION']}"
set :nvm_map_bins, %w{node yarn cross-env}
set :nvm_node_path, -> {
  if fetch(:nvm_type, :user) == :system
    '/usr/local/nvm/'
  else
    "$HOME/.nvm/"
  end
}

# yarn settings
set :yarn_flags, ''           # default
set :yarn_roles, :all         # default
set :yarn_env_variables, {}   # default




namespace :deploy do

  before "nvm:wrapper", :show_information do
    on roles(:app), in: :groups, limit: 3 do

      execute "php -v"
      # execute "#{fetch(:exec_phpbrew)} && php -v"
      execute "echo '============================================================'"

    end
  end

#  after "deploy:updated", :laravel_tasks do
#    invoke "laravel:migrate_db", :'--force'
#  end

  after 'deploy:symlink:release', :update_php_fpm do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      # debug log
      execute "echo '' > /tmp/screenshot"
      execute "ls -lhA --time-style=long-iso '#{fetch(:deploy_to)}/'        >> /tmp/screenshot"
      execute "ls -lhA --time-style=long-iso '#{fetch(:deploy_to)}/current' >> /tmp/screenshot"
      execute "cd '#{fetch(:deploy_to)}/current' && pwd >> /tmp/screenshot && ls -lhA --time-style=long-iso >> /tmp/screenshot"
      execute "cat /tmp/screenshot"
    end
  end

  after 'deploy:symlink:release', :update_php_fpm do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      #
      # execute "cd '#{fetch(:deploy_to)}/current' && #{fetch(:exec_phpbrew)} && php --version && php autorun.php"
      # execute "cd '#{fetch(:deploy_to)}/current' && #{fetch(:exec_nvm)}     && yarn"
      # execute "sudo supervisorctl reread && sudo supervisorctl update && sudo service supervisor reload"
      # execute :phpbrew, :fpm, :start
      # execute :sudo, :service, 'supervisor', 'restart'
    end
  end

  after 'deploy:symlink:release', :update_php_fpm do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      # clear laravel cache
      execute "    #{fetch(:exec_phpbrew)}              \
                                                        \
                && cd '#{fetch(:deploy_to)}/current'    \
                && echo                                 \
                && php artisan config:clear && php artisan cache:clear && php artisan route:clear && php artisan view:clear                         \
      "
    end
  end

  after 'deploy:symlink:release', :update_php_fpm do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      # apidoc
      execute "cd '#{fetch(:deploy_to)}/current' && apidoc -i ./Modules/ -o ./public/apidoc"
    end
  end

end



# see https://github.com/SimplyBridal/kid-guard-backend/blob/master/config/deploy.rb
