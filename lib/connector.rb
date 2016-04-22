require 'octokit'

class Connector
  attr_accessor :foo

  def initialize
    @client = Octokit::Client.new(login: '', password: '')
  end

  def connect
    puts @client.user
  end
end
