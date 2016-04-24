require 'net/http'
require 'pry'
require 'yaml'
require_relative './parser'

class Connector
  attr_accessor :response, :q, :page, :per_page

  def initialize(options = {})
    @options = options
    validates_params
    @q = options[:q]
    @per_page = options[:per_page]
    @page = 1
    build_params(@q, @per_page)
    login
  end

  def build_params(q="crystal", per_page="10", page="1")
    @params = '?'
    @params += "q=#{q}&"
    @params += "per_page=#{per_page}&"
    @params += "page=#{page}&"
  end

  def get
    uri = URI("https://api.github.com/search/repositories#{@params}")
    response = Net::HTTP.get(uri)
    fail "Nothing is returned by getting #{uri}." unless response
    puts "Fetching repo from: #{uri}"
    @response = JSON.parse(response)
    @count ||= @response["total_count"].to_i
  end

  def iterate
    get unless @count
    @page = 0
    while @count > 0 do
      build_params(@q, @per_page, @page += 1)
      get
      Parser.new(@response["items"]).parse
      @count -= @per_page
    end
  end

  def validates_params
    fail 'params q is not set' unless @options[:q]
  end

  def login
    yml   = YAML.load_file(File.join(File.dirname(__FILE__), '../config/application.yml'))
    token = yml['token']['github']
    Octokit::Client.new(access_token: token).user.login
  end
end
