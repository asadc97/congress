require 'sinatra'
require 'sinatra/json'
require 'httparty'

class RepFinder

  # when we create a new instance of RepFinder, we pass it the zip code
  def initialize(zip)
    @api_key = "e8863bbca4774d588ff7b952acf3a1fd" # remember to add your API key!
    @zip = zip
  end

  # we construct the URL using the @zip and @api_key variables
  def url
    "http://congress.api.sunlightfoundation.com/legislators/locate?zip=#{@zip}&apikey=#{@api_key}"
  end

  # we pass the url method from above into HTTParty.get ...
  # and then get just the body (which has all the content we need)
  def get_response
    HTTParty.get(url).body
  end

  # take the response from the method above (which is in JSON)
  # and parse it! :)
  def parse_response
    JSON.parse(get_response)
  end

end

# the methods below are used to display our web pages
# 'get' means the user is getting content from the server
# 'post' means the user is giving the server content
# 'not_found' is our '404' page

# when we're at root level, display form.erb
get '/' do
  erb :form
end

# when we post using form.erb, we collect a zip value
post '/' do
  # pass zip to RepFinder
  new_query = RepFinder.new(params[:zip])
  # parse_response 'peels the onion' giving us the data we
  # want to work with :)
  @congress = new_query.parse_response
  # we then store all the data in @congress, which we pass
  # to results.erb
  erb :results
end

# our '404' page. Nothing special, oops.erb just re-directs us to
# the home page. :)
not_found do
  erb :oops
end
