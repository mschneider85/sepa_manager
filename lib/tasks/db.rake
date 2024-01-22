namespace :db do
  desc "Pulls a database dump from the server and imports it locally"
  task pull: :environment do
    prompt = TTY::Prompt.new

    server_address = prompt.ask("Enter the server address:", default: ENV.fetch("PROD_SERVER_ADDRESS"))
    db_name = prompt.ask("Enter the database name:", default: ENV.fetch("PROD_DB_NAME"))
    db_config = Rails.application.config.database_configuration[Rails.env]

    system("ssh #{server_address} \"dokku postgres:enter #{db_name} pg_dump #{db_name.underscore} -U postgres -h localhost --data-only | tail -n +2\" > dump")
    Rake::Task["db:drop"].invoke && Rake::Task["db:create"].invoke && Rake::Task["db:migrate"].invoke
    system("PGPASSWORD=#{db_config['password']} psql -U postgres -h #{db_config['host']} #{db_config['database']} < dump")
    File.delete("dump")
  end
end
