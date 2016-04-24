require 'net/http'
require 'json'
require 'active_record'
require_relative './database/repository'

class Parser
  def initialize(repos = [])
    @repos = repos
  end

  def parse
    Database.connect
    @repos.each do |repo|
      next if Database::Repository.find_by_github_id(repo['id'])
      if crystal?(repo)
        Database::Repository.create!(
          owner:     repo['owner']['login'],
          repo:      repo['name'],
          languages: @languages,
          github_id: repo['id'],
          has_doc:   false
        )
        puts "Created: #{repo['full_name']}"
      else
        puts "Skipped: #{repo['full_name']}"
      end
    end
  end

  def crystal?(repo)
    uri = URI(repo['languages_url'])
    @languages = JSON.parse(Net::HTTP.get(uri))
    fail "Error: API rate limit exceeded." if exceeded?
    return false unless @languages.keys.include?('Crystal')
    total = @languages.inject(0) { |r, p| r += p[1] }
    (@languages['Crystal'].to_f / total.to_f) > 0.5
  end

  def exceeded?
    @languages["message"].to_s.include?("API rate limit exceeded") 
  end
end
