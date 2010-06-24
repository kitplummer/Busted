require 'rubygems'
require 'sinatra'

get '/' do 
	"Hello from Busted, the SunTran WebWatch Feed Proxy!"
end

get '/route/:id' do |route|
  "Fetching route: #{route}"
end


