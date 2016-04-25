require 'net/http'
require 'pry'
require 'yaml'
require 'octokit'
require_relative './parser'
require_relative './connector_params'

class Connector
  attr_accessor :response, :q, :page, :per_page

  def initialize(options = {})
    options[:url] = "https://api.github.com/search/repositories"
    @params = Params.new(options)
    @client = login
  end

  def get
    @response = @client.get(@params.uri)
    fail "Nothing is returned by getting #{@params.uri}." unless @response
    puts "Fetching repo from: #{@params.uri}" unless @count
    @count ||= @response["total_count"].to_i
  end

  def iterate
    get unless @count
    while @count > 0 do
      @params.next_page
      get
      Parser.new(@response["items"]).parse
      @count -= @params.per_page
    end
  end

  def login
    yml   = YAML.load_file(File.join(File.dirname(__FILE__), '../config/application.yml'))
    id = yml['github']['oauth']['id']
    secret = yml['github']['oauth']['secret']
    user = yml['github']['user']
    Octokit::Client.new(
      client_id: id,
      client_secret: secret
    )
  end
end
