require 'rubygems'
require 'sinatra'
require 'httparty'
require 'haml'
require 'nokogiri'
require 'builder'
require 'json'
require 'open-uri'

configure :production do
    require 'newrelic_rpm'
end

require 'busted_xml'

# JSON builders
require 'busted_json'

get '/' do 
  haml :index
end

#### ALPHA API Routes ####
get '/alpha/route/:id.xml' do |route|
  content_type 'application/xml', :charset => 'utf-8'
  BustedXml.xml(route, "all")
end

get '/alpha/route/:id/stations.xml' do |route|
  content_type 'application/xml', :charset => 'utf-8'
  BustedXml.xml(route, "stations")
end

get '/alpha/route/:id/stops.xml' do |route|
  content_type 'application/xml', :charset => 'utf-8'
  BustedXml.xml(route, "stops")
end

get '/alpha/route/:id/busses.xml' do |route|
  content_type 'application/xml', :charset => 'utf-8'
  BustedXml.xml(route, "busses")
end

### KML ###

get '/alpha/route/:id/busses.kml' do |route|
  #content_type 'application/vnd.google-earth.kml+xml', :charset => 'utf-8'
  content_type 'application/xml', :charset => 'utf-8'
  BustedXml.kml(route, "busses")
end

get '/alpha/route/:id/stops.kml' do |route|
  #content_type 'application/vnd.google-earth.kml+xml', :charset => 'utf-8'
  content_type 'application/xml', :charset => 'utf-8'
  BustedXml.kml(route, "stops")
end

# In development generation of route lines in KML
get '/alpha/route/:id/trace.kml' do |route|
  content_type 'application/xml', :charset => 'utf-8'
  BustedXml.trace_kml(route)
end

#### Beta API Routes ####
get '/beta/route/:id.xml' do |route|
  content_type 'application/xml', :charset => 'utf-8'
  BustedXml.xml(route, "all")
end

get '/beta/route/:id/stations.xml' do |route|
  content_type 'application/xml', :charset => 'utf-8'
  BustedXml.xml(route, "stations")
end

get '/beta/route/:id/stops.xml' do |route|
  content_type 'application/xml', :charset => 'utf-8'
  BustedXml.xml(route, "stops")
end

get '/beta/route/:id/busses.xml' do |route|
  content_type 'application/xml', :charset => 'utf-8'
  BustedXml.xml(route, "busses")
end

### JSON ###

get '/beta/route/:id.json' do |route|
  callback = params.delete('callback') #for jsonp
  json = BustedJson.all(route)

  if callback
    content_type :js
    response = "#{callback}(#{json})"
  else
    content_type 'application/json', :charset => 'utf-8'
    response = json
  end

  response
end

get '/beta/route/:id/stations.json' do |route|
  callback = params.delete('callback')
  json = BustedJson.stations(route)

  if callback
    content_type :js
    response = "#{callback}(#{json})"
  else
    content_type 'application/json', :charset => 'utf-8'
    response = json
  end

  response
end

get '/beta/route/:id/stops.json' do |route|
  callback = params.delete('callback')
  json = BustedJson.stops(route)

  if callback
    content_type :js
    response = "#{callback}(#{json})"
  else
    content_type 'application/json', :charset => 'utf-8'
    response = json
  end

  response
end

get '/beta/route/:id/busses.json' do |route|
  callback = params.delete('callback')
  json =   BustedJson.busses(route)
  if callback
    content_type :js
    response = "#{callback}(#{json})"
  else
    content_type 'application/json', :charset => 'utf-8'
    response = json
  end

  response
end

### KML ###

get '/beta/route/:id/busses.kml' do |route|
  #content_type 'application/vnd.google-earth.kml+xml', :charset => 'utf-8'
  content_type 'application/xml', :charset => 'utf-8'
  BustedXml.kml(route, "busses")
end

get '/beta/route/:id/stops.kml' do |route|
  #content_type 'application/vnd.google-earth.kml+xml', :charset => 'utf-8'
  content_type 'application/xml', :charset => 'utf-8'
  BustedXml.kml(route, "stops")
end

# In development generation of route lines in KML
get '/beta/route/:id/trace.kml' do |route|
  content_type 'application/xml', :charset => 'utf-8'
  BustedXml.trace_kml(route)
end

get '/test/routes.json' do 
  content_type :json
  
  doc = Nokogiri::HTML(open("http://www.suntran.com/routes.php"))

  # get the right tr elements
  nodes = doc.xpath('/html/body/div[15]/table[2]/tr/td[@class = "bdr"]')

  # load everything into an array
  stuff = []
  nodes.each do |node|
    if node.text != "?"
      stuff << node.text.lstrip.rstrip
    end
  end

  # clean the junk
  stuff.delete("\302\240")

  h = Hash[*stuff]
  # take a peek at the hash    
  h.to_json
end

get '/beta/routes.json' do
  callback = params.delete('callback')

  json = '''{"routes":[
  {"id":"1", "name":"Glenn/Swan"},
  {"id":"2", "name":"Cherrybell/Country Club"},
  {"id":"3", "name":"6th St./Wilmot"},
  {"id":"4", "name":"Speedway"},
        {"id":"5", "name":"Pima St./W. Speedway"},
  {"id":"6", "name":"S. Park Ave./N. 1st Ave."},
  {"id":"7", "name":"22nd St."},
  {"id":"8", "name":"Broadway/6th Ave."},
  {"id":"9", "name":"Grant"},
  {"id":"10", "name":"Flowing Wells"},
  {"id":"11", "name":"Alvernon"},
  {"id":"15", "name":"Campbell"},
  {"id":"16", "name":"12th Ave./Oracle"},
  {"id":"17", "name":"Country Club/29th St."},
  {"id":"19", "name":"Stone"},
  {"id":"20", "name":"W. Grant/Ironwood Hills"},
  {"id":"21", "name":"W. Congress/Silverbell"},
  {"id":"22", "name":"Grande"},
  {"id":"23", "name":"Mission"},
  {"id":"24", "name":"12th Avenue"},
  {"id":"26", "name":"Benson Highway"},
  {"id":"27", "name":"Midvale Park"},
  {"id":"29", "name":"Valencia"},
  {"id":"34", "name":"Craycroft"},
  {"id":"37", "name":"Pantano"},
  {"id":"50", "name":"Ajo Way"},
  {"id":"61", "name":"La Cholla"},
  {"id":"101X", "name":"Golf Links-Downtown Express"},
  {"id":"102X", "name":"Northwest-UA Express"},
  {"id":"103X", "name":"Northwest-Downtown Express"},
  {"id":"104X", "name":"Marana-Downtown Express"},
  {"id":"105X", "name":"Foothills-Downtown Express"},
  {"id":"107X", "name":"Oro Valley-Downtown Express"},
  {"id":"108X", "name":"Broadway-Downtown Express"},
  {"id":"109X", "name":"Catalina Hwy-Downtown Express"},
  {"id":"110X", "name":"Rita Ranch-Downtown Express"},
  {"id":"201X", "name":"Eastside-Aero Park Express"},
  {"id":"202X", "name":"Northwest-Aero Park Express"},
  {"id":"203X", "name":"Oro Valley-Aero Park Express"},
  {"id":"312X", "name":"Oro Valley-Tohono Express"}
    ]}'''

    if callback
      content_type :js
      response = "#{callback}(#{json})"
    else
      content_type 'application/json', :charset => 'utf-8'
      response = json
    end

    response
end

get '/beta/routes.xml' do
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
