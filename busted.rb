require 'rubygems'
require 'sinatra'
require 'httparty'
require 'builder'
require 'haml'

ALL, STATIONS, STOPS, BUSSES = false

get '/' do 
  haml :index
end


get '/alpha/route/:id' do |route|
  content_type 'application/xml', :charset => 'utf-8'
  build_xml(route, "all")
end

get '/alpha/route/:id/stations' do |route|
  content_type 'application/xml', :charset => 'utf-8'
  build_xml(route, "stations")
end

get '/alpha/route/:id/stops' do |route|
  content_type 'application/xml', :charset => 'utf-8'
  build_xml(route, "stops")
end

get '/alpha/route/:id/busses' do |route|
  content_type 'application/xml', :charset => 'utf-8'
  build_xml(route, "busses")
end

get '/alpha/routes/' do
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
    <route id="202X">Northwest-Aero Park  Express</route> 
    <route id="203X">Oro Valley-Aero Park  Express</route> 
    <route id="312X">Oro Valley-Tohono Express</route>
  </routes>'''
end

def build_xml(route, section)
  response = HTTParty.get("http://www.suntran.com/webwatch/UpdateWebMap.aspx?u=#{route}")  
  res = response.body.split('*')
  builder = Builder::XmlMarkup.new

  builder.instruct!
  builder.comment! "proxy service to access the SunTran WebWatch data."


  xml = builder.route(:requested => res[0], :id => route) { |b|

    # stations and departures
    # 32.1634229|-110.9441526|IRVINGTON & CAMPBELL|South |7:46 AM<br>8:18 AM<br>8:46 AM<br>|7

    if section == "all" || section == "stations" || section == "stops" 
      b.stations { |station|
        s_stations = res[1].split(';')
        s_stations.each do |s_station|
          station.station { |s|
            station_data = s_station.split('|')
            s.name station_data[2]
            s.lat station_data[0]
            s.lng station_data[1]
            s.direction station_data[3].chop
            s.departures { |d| 
              deps = station_data[4].split('<br>')
              deps.each do |dep|
                d.time dep
              end
            }
          }
        end
      }
    end
    puts "SECTION #{section}"
    # stops and departures
    
    if section == "all" || section == "stops"
      b.stops { |stop|
        s_stops = res[3].split(';')
        s_stops.each do |s_stop|
          stop.stop { |s|
            stop_data = s_stop.split('|')
            s.name stop_data[2]
            s.lat stop_data[0]
            s.lng stop_data[1]
            s.direction stop_data[3].chop
            s.departures { |d| 
              deps = stop_data[4].split('<br>')
              deps.each do |dep|
                d.time dep
              end
            }
          }
        end
      }
    end
    # busses
    # Bus: 32.1898495|-110.9292197|2|<b>South </b><br>Next Timepoint: FORGEUS AT PRESIDENT (KINO HOSP)

    if section == "all" || section == "busses"    
      s_busses     = res[2].split(';')

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

    end
  }

  return xml
end