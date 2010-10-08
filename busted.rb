require 'rubygems'
require 'sinatra'
require 'httparty'
require 'builder'
require 'haml'

# XML and KML output builders
require 'builders'

get '/' do 
  haml :index
end

get '/alpha/route/:id.xml' do |route|
  content_type 'application/xml', :charset => 'utf-8'
  Builder.xml(route, "all")
end

get '/alpha/route/:id/stations.xml' do |route|
  content_type 'application/xml', :charset => 'utf-8'
  Builder.xml(route, "stations")
end

get '/alpha/route/:id/stops.xml' do |route|
  content_type 'application/xml', :charset => 'utf-8'
  Builder.xml(route, "stops")
end

get '/alpha/route/:id/busses.xml' do |route|
  content_type 'application/xml', :charset => 'utf-8'
  Builder.xml(route, "busses")
end

get '/alpha/route/:id/busses.kml' do |route|
  #content_type 'application/vnd.google-earth.kml+xml', :charset => 'utf-8'
  content_type 'application/xml', :charset => 'utf-8'
  Builder.kml(route, "busses")
end

get '/alpha/route/:id/stops.kml' do |route|
  #content_type 'application/vnd.google-earth.kml+xml', :charset => 'utf-8'
  content_type 'application/xml', :charset => 'utf-8'
  Builder.kml(route, "stops")
end

# In development generation of route lines in KML
get '/alpha/route/:id/trace.kml' do |route|
  content_type 'application/xml', :charset => 'utf-8'
  Builders.trace_kml(route)
end

get '/beta/routes.json' do
  content_type 'application/json', :charset => 'utf-8'
  '''{"routes":[
	{"id":"1", "name":"Glenn/Swan"},
	{"id":"2", "name":"Cherrybell/Country Club"},
	{"id":"3", "name":"6th St./Wilmot"},
	{"id":"4", "name":"Speedway"},
      	{"id":"5", "name":"Pima St./W. Speedway"}
    ]}'''
end

get '/alpha/routes.xml' do
  content_type 'application/xml', :charset => 'utf-8'

  '''<routes>    
  <route id="1">Glenn/Swan</route> 
  <route id="2">Cherrybell/Country Club</route> 
  <route id="3">6th St./Wilmot</route> 
  <route id="4">Speedway</route> 
  <route id="5">Pima St./W. Speedway</route> 
  <route id="6">S. Park Ave./N. 1st Ave.</route> 
  <route id="7">22nd St.</route> 
  <route id="8">Broadway/ 6th Ave.</route> 
  <route id="9">Grant </route> 
  <route id="10">Flowing Wells</route> 
  <route id="11">Alvernon</route> 
  <route id="15">Campbell </route> 
  <route id="16">12th Ave./Oracle</route> 
  <route id="17">Country Club/29th St.</route> 
  <route id="19">Stone</route> 
  <route id="20">W. Grant/Ironwood Hills</route> 
  <route id="21">W. Congress/Silverbell</route> 
  <route id="22">Grande</route> 
  <route id="23">Mission</route> 
  <route id="24">12th Avenue</route> 
  <route id="26">Benson Highway</route> 
  <route id="27">Midvale Park</route> 
  <route id="29">Valencia</route> 
  <route id="34">Craycroft</route> 
  <route id="37">Pantano</route> 
  <route id="50">Ajo Way</route> 
  <route id="61">La Cholla</route> 
  <route id="101X">Golf Links-Downtown Express</route> 
  <route id="102X">Northwest-UA Express</route> 
  <route id="103X">Northwest-Downtown Express</route> 
  <route id="104X">Marana-Downtown Express</route> 
  <route id="105X">Foothills-Downtown Express</route> 
  <route id="107X">Oro Valley-Downtown Express</route> 
  <route id="108X">Broadway-Downtown Express</route> 
  <route id="109X">Catalina Hwy-Downtown Express</route> 
  <route id="110X">Rita Ranch-Downtown Express</route> 
  <route id="201X">Eastside-Aero Park Express</route> 
  <route id="202X">Northwest-Aero Park Express</route> 
  <route id="203X">Oro Valley-Aero Park sExpress</route> 
  <route id="312X">Oro Valley-Tohono Express</route>
  </routes>'''
end

