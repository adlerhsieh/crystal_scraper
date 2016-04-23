require 'net/http'
require 'pry'
require 'yaml'
require_relative './parser'

class Connector
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
    Parser.new(response).parse
  end

  def validates_params
    raise "params q is not set" unless @options[:q]
  end

  def login
    yml   = YAML.load_file(File.join(File.dirname(__FILE__), "../config/application.yml"))
    token = yml["token"]["github"]
    Octokit::Client.new(access_token: token).user.login
  end
end
