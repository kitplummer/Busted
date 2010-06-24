require 'rubygems'
require 'sinatra'
require 'httparty'
require 'builder'

get '/' do 
	"Hello from Busted, the SunTran WebWatch Feed Proxy!"
end

get '/route/:id' do |route|
  "Fetching all information for route: #{route}"
end

get '/route/:id/stations' do |route|
  "Fetching all station information for route: #{route}"
end

get '/route/:id/stops' do |route|
  "Fetching all stop (including stations) information for route: #{route}"
end

get '/route/:id/busses' do |route|
  "Fetching all bus information for route: #{route}"
end
