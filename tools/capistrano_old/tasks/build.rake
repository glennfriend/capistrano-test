namespace :build do
  task :prod do
    on roles(:app) do
      within release_path do
        execute :yarn, "prod"
      end
    end
  end
end
