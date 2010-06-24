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
  content_type 'application/xml', :charset => 'utf-8'
  
  # "Fetching all bus information for route: #{route}"
  response = HTTParty.get("http://www.suntran.com/webwatch/UpdateWebMap.aspx?u=#{route}")
  res = response.body.split('*')

  builder = Builder::XmlMarkup.new

  builder.instruct!
  builder.comment! "proxy service to access the SunTran WebWatch data."


  xml = builder.route(:requested => res[0], :id => route) { |b|

    # busses
    # Bus: 32.1898495|-110.9292197|2|<b>South </b><br>Next Timepoint: FORGEUS AT PRESIDENT (KINO HOSP)

    s_busses = res[2].split(';')

    b.busses { |bus|
      s_busses.each do |s_bus|
        bus_data = s_bus.split('|')
        bus.bus { |b|
          b.lat bus_data[0]
          b.lng bus_data[1]
          b.direction bus_data[2]
          b.nextstop bus_data[3]
        }
      end
    }
  }

  xml
end
