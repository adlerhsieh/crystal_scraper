require 'net/http'
require 'json'
require 'active_record'
require 'pry'
require_relative './database/repository'
require_relative './conf'

class Parser
  def initialize(repos = [])
    @repos = repos
  end

  def parse
    Database.connect
    @repos.each do |repo|
      next if Database::Repository.find_by_github_id(repo['id'])
      repository = Database::Repository.new(
        owner:     repo['owner']['login'],
        repo:      repo['name'],
        languages: languages(repo),
        github_id: repo['id'],
        has_doc:   false
      )
      repository.save!
      puts "Created: #{repo['full_name']}"
    end
  end

  def languages(repo)
    uri = authenticated_uri(repo["languages_url"])
    @languages = JSON.parse(Net::HTTP.get(uri))
    fail "Error: API rate limit exceeded." if exceeded?
    @languages
  end

  def exceeded?
    @languages["message"].to_s.include?("API rate limit exceeded") 
  end

  def authenticated_uri(url)
    client_id = Conf.yml['github']['oauth']['id']
    client_secret = Conf.yml['github']['oauth']['secret']
    URI("#{url}?client_id=#{client_id}&client_secret=#{client_secret}")
  end
end
