require 'cached_belongs_to'
require './spec/support/warnings.rb'

ActiveRecord::Migration.verbose = false
ActiveRecord::Base.logger = Logger.new("test.log")
ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
