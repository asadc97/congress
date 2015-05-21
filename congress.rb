require 'sinatra'
require 'shotgun'
require 'httparty'

class RepFinder

  def initialize(zip)
    @api_key = ""
    @zip = zip
  end

  def url
    "http://congress.api.sunlightfoundation.com/legislators/locate?zip=#{@zip}&apikey=#{@api_key}"
  end

  def get_response
    HTTParty.get(url)
  end
end

get '/' do
  erb :form
end

post '/' do
  # pass zip to RepFinder
  new_query = RepFinder.new(params[:zip])
  # get the response, and isolate the body
  new_query.get_response.body
end

not_found do
  erb :oops
end
