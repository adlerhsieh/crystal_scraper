require 'active_record'
require_relative './database'

class Database::Repository < ActiveRecord::Base
  serialize :languages
  after_save :crystal?

  def crystal?
    return if self.crystal
    return update_column(:crystal, false) unless crystal_repo?
    crystal    = self.languages['Crystal'].to_f
    total      = self.languages.inject(0) { |r, p| r += p[1] }.to_f
    percentage = crystal / total
    update_column(:crystal, percentage > 0.5)
  end

  def crystal_repo?
    self.languages.keys.include?('Crystal') 
  end
end
