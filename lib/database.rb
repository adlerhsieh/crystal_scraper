require 'octokit'
require 'active_record'

class Database
  def self.connect
    yml = File.join(File.dirname(__FILE__), "../config/application.yml") 
    db = YAML.load_file(yml)["database"]
    ActiveRecord::Base.establish_connection(
      adapter: "mysql",
      host:     "localhost",
      username: db["username"],
      password: db["password"],
      database: db["database"]
    )
  end

  class Repository < ActiveRecord::Base
    self.table_name = "repositories"
    serialize :languages
  end

  class Schema
    def initialize
      ::Database.connect
      @con = ActiveRecord::Base.connection
    end

    def maintain
      create_schema
    end

    def reset
      @con.tables.each {|table| @con.drop_table(table.to_sym) }
      create_schema
    end

    def connect
    end

    def create_schema
      unless @con.table_exists?("repositories")
        @con.create_table :repositories do |t|
          t.string  :owner
          t.string  :repo
          t.text    :languages
          t.boolean :has_doc
          t.integer :github_id
          t.time    :deleted_at
          t.timestamps null: false
        end
      end
    end
  end
end
