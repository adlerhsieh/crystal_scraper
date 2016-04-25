require 'active_record'
require_relative './database'

class Database::Schema
  def initialize
    ::Database.connect
    @con = ActiveRecord::Base.connection
  end

  def maintain
    create_schema
  end

  def reset
    @con.tables.each { |table| @con.drop_table(table.to_sym) }
    create_schema
  end

  def connect
  end

  def create_schema
    return if @con.table_exists?('repositories')
    @con.create_table :repositories do |t|
      t.string :owner
      t.string :repo
      t.text :languages
      t.boolean :has_doc
      t.integer :github_id
      t.boolean :crystal
      t.time :deleted_at
      t.timestamps null: false
    end
  end
end
