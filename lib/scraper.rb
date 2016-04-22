require 'net/http'
require 'pry'
require 'json'

class Scraper
  attr_accessor :response, :q, :page, :per_page

  def initialize(options={})
    @options = options
    validates_params
    build_params
    login
  end

  def build_params
    @params = "?"
    @params += "q=#{@options[:q]}&"               if @options[:q]
    @params += "per_page=#{@options[:per_page]}&" if @options[:per_page]
    @params += "page=#{@options[:page]}&"         if @options[:page]
  end

  def get
    uri = URI("https://api.github.com/search/repositories#{@params}")
    response = Net::HTTP.get(uri)
    raise "Nothing is returned by getting #{uri}." unless @response
    @response = JSON.parse(response)
  end

  def validates_params
    raise "params q is not set" unless @options[:q]
  end

  def login
    token = "25f60e30b657755f324bc5d86689338e882655de"
    Octokit::Client.new(access_token: token).user.login
  end
end
