require 'cached_belongs_to'

ActiveRecord::Migration.verbose = false
ActiveRecord::Base.logger = Logger.new("log/test.log")
ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
