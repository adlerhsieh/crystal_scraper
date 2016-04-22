require 'octokit'
require 'active_record'

class Database
  class Schema
    def initialize
      connect
      @con = ActiveRecord::Base.connection
    end

    def maintain
      create_schema
    end

    def rebuild
      @con.tables.each {|table| @con.drop_table(table.to_sym) }
      create_schema
    end

    def connect
      db = YAML.load_file(File.join(File.dirname(__FILE__), "../config/application.yml"))["database"]
      ActiveRecord::Base.establish_connection(
        adapter: "mysql",
        host:     "localhost",
        username: db["username"],
        password: db["password"],
        database: db["database"]
      )
    end

    def create_schema
      unless @con.table_exists?("repositories")
        @con.create_table :repositories do |t|
          t.string "user"
          t.string "repo"
          t.timestamps null: false
        end
      end
    end
  end
end
