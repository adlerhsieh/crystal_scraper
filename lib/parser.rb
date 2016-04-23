require 'net/http'
require 'json'
require 'active_record'
require_relative "./database"

class Parser
  def initialize(content=nil)
    raise "Nothing is returned by getting #{uri}." unless content
    @content = JSON.parse(content)["items"]
  end

  def parse
    Database.connect
    @content.each do |repo|
      next if Database::Repository.find_by_github_id(repo["id"])
      next unless crystal?(repo)
      Database::Repository.create!(
        owner: repo["owner"]["login"],
        repo: repo["name"],
        languages: @languages,
        github_id: repo["id"],
        has_doc: false,
      )
    end
  end

  def crystal?(repo)
    uri = URI(repo["languages_url"])
    @languages = JSON.parse(Net::HTTP.get(uri))
    return false unless @languages.keys.include?("Crystal")
    total = @languages.inject(0) {|r,p| r += p[1] }
    return (@languages["Crystal"].to_f / total.to_f) > 0.5
  end
end
