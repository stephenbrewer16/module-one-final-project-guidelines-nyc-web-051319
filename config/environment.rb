require 'bundler'
Bundler.require

ActiveRecord::Base.logger = nil
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
# ENV['SINATRA_ACTIVESUPPORT_WARNING']=false

require_all 'app'
