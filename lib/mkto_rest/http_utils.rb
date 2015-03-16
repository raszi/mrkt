require 'uri' unless defined? URI
require 'net/https' unless defined? Net::HTTP

module MktoRest

  class HttpUtils

    class << self; attr_accessor :debug; end

    # \options:
    #   open_timeout - if non default timeout needs to be used
    #   read_timeout - if non default timeout needs to be used
    def self.get(endpoint, args = {}, options = {})
      uri = URI.parse(endpoint + '?' + URI.encode_www_form(args))
      req = Net::HTTP::Get.new(uri.request_uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.set_debug_output($stdout) if self.debug == true
      http.use_ssl = (uri.scheme == "https")
      http.open_timeout = options[:open_timeout] if options[:open_timeout]
      http.read_timeout = options[:read_timeout] if options[:read_timeout]
      resp = http.request(req)
      resp.body
    end

    # \options:
    #   open_timeout - if non default timeout needs to be used
    #   read_timeout - if non default timeout needs to be used
    def self.post(endpoint, headers, data, options = {})
      uri = URI.parse(endpoint)
      req = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})
      req.body = data
      headers.each { |k,v| req[k] = v }
      http = Net::HTTP.new(uri.host, uri.port)
      http.set_debug_output($stdout) if self.debug == true
      http.use_ssl = (uri.scheme == "https")
      http.open_timeout = options[:open_timeout] if options[:open_timeout]
      http.read_timeout = options[:read_timeout] if options[:read_timeout]
      resp = http.request(req)
      resp.body
    end
  end
end
