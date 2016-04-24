require 'octokit'
require 'active_record'

class Database
  def self.connect
    yml = File.join(File.dirname(__FILE__), '../../config/application.yml')
    db = YAML.load_file(yml)['database']
    ActiveRecord::Base.establish_connection(
      adapter: 'mysql',
      host:     'localhost',
      username: db['username'],
      password: db['password'],
      database: db['database']
    )
  end
end
