module Builders
  def Builders.trace_kml(route)
    response = HTTParty.get("http://www.suntran.com/webwatch/Scripts/Route#{route}_trace.js")
    js_trace = response.body.split('*')[1].split('|')
    
    builder = Builder::XmlMarkup.new

    builder.instruct!
    builder.comment! "proxy service to access the SunTran WebWatch data."


    kml = builder.kml(:xmlns => "http://www.opengis.net/kml/2.2") { |root|
      root.Document { |doc|
      
        doc.name "Route Number: #{route}"
            
        doc.Style(:id => "yellowLineGreenPoly") { |ylgp|
          ylgp.LineStyle { |line_style|
            line_style.color "7fff0000"
            line_style.width "4"
          }
          ylgp.PolyStyle { |poly_style|
            poly_style.color "7fff0000"
          }
        }
      
        js_trace.each { |line|
          #puts "Line: " + line
          doc.Placemark { |p|
            p.styleUrl "#yellowLineGreenPoly"
            p.LineString { |ls|
              ls.extrude "1"
              ls.tessellate "1"
              ls.altitudeModel "absolute"
              coords = ''
              points = line.split(';')
              points.each do |point|
  
                coords = coords + "#{point.gsub(' ', ',')}\n"
              end
              ls.coordinates coords
            }
  
          }
        }
      }
    }
  end
  
  def Builder.xml(route, section)
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
              b.direction bus_data[3].split('<br>')[0]
              b.comment! "No clue what Next Timepoint is???"
              b.destination bus_data[3].split('<br>')[1]
            }
          end
        }

      end
    }

    return xml
  end

  def Builder.kml(route, section)
    response = HTTParty.get("http://www.suntran.com/webwatch/UpdateWebMap.aspx?u=#{route}")  
    res = response.body.split('*')
    builder = Builder::XmlMarkup.new

    builder.instruct!
    builder.comment! "proxy service to access the SunTran WebWatch data."


    kml = builder.kml(:xmlns => "http://www.opengis.net/kml/2.2") { |root|
      root.Document { |doc|
        doc.name "Route Number: #{route}"
        doc.Style(:id => "busMark") { |style|
          style.IconStyle { |iconstyle|
            iconstyle.Icon { |icon|
              icon.href "../../../images/BusEast.png"
            }
          }
        }

        if section == "all" || section == "busses"    
          s_busses = res[2].split(';')

          s_busses.each do |s_bus|
            bus_data = s_bus.split('|')
            doc.Placemark { |p|
              p.styleUrl "#busMark"
              p.name "Bus on Route #{route}"
              p.comment! "No clue what Next Timepoint is???"
              p.description bus_data[3].split('<br>')[1]
              p.Point { |point|
                point.coordinates "#{bus_data[1]},#{bus_data[0]},0"
              }
            }
          end

        end
        
      }
    }
  end
end