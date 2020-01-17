namespace :chargeback do
  task :test_select do
    on roles(:app) do
      within release_path do
        execute :php, :artisan, 'test:select'
      end
    end
  end
end
