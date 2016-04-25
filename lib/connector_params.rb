require 'net/http'

class Connector
  class Params
    attr_accessor :q, :per_page, :page

    def initialize(options)
      @q             = options[:q]
      @per_page      = options[:per_page]
      @page          = options[:page] || 0
      @url           = options[:url]
      validate
    end

    def next_page
      @per_page += 1
    end

    def to_s
      "?q=#{@q}&per_page=#{@per_page}&page=#{@page}"
    end

    def uri
      URI("#{@url}#{to_s}")
    end

    def validate
      fail 'params q is not set' unless @q
    end
  end
end
