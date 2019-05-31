require 'bundler'
Bundler.require

ActiveRecord::Base.logger = nil

SINATRA_ACTIVESUPPORT_WARNING=false

require_all 'app'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
