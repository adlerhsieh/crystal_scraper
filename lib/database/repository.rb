require 'active_record'
require_relative './database'

class Database::Repository < ActiveRecord::Base
  serialize :languages
end
