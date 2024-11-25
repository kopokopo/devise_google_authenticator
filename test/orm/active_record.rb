require 'active_record'

ActiveRecord::Migration.verbose = false
ActiveRecord::Base.logger = Logger.new(nil)

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

migrations_path = File.expand_path("../../rails_app/db/migrate/", __FILE__)
ActiveRecord::MigrationContext.new(migrations_path).migrate