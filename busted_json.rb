require 'rubygems'
require 'httparty'
require 'route'
require 'station'
require 'stop'
require 'bus'

module BustedJson
    def BustedJson.all(route)
        @res = fetch(route)
        @r = Route.new(route, @res[0])
        parse_stations(@res, @r)
        parse_stops(@res, @r)
        parse_busses(@res, @r)
        @r.to_json
    end

    def BustedJson.stations(route)
        @res = fetch(route)
        @r = Route.new(route, @res[0])
        parse_stations(@res, @r)
        @r.to_json
    end

    def BustedJson.stops(route)
        @res = fetch(route)
        @r = Route.new(route, @res[0])
        parse_stops(@res, @r)
        @r.to_json
    end

    def BustedJson.busses(route)
        @res = fetch(route)
        @r = Route.new(route, @res[0])
        parse_busses(@res, @r)
        @r.to_json
    end

    def BustedJson.fetch(route)
        HTTParty.get("http://www.suntran.com/webwatch/UpdateWebMap.aspx?u=#{route}").body.split('*')
    end

    def BustedJson.parse_stations(res, route)
        stats = res[1].split(';')
        stats.each do |stat|
            sd = stat.split("|")

            s = Station.new(sd[2],sd[0],sd[1],sd[3].chop,sd[4].split("<br>"))
            route.stations << s
        end
    end

    def BustedJson.parse_stops(res, route)
        stops = res[3].split(';')
        stops.each do |stop|
            sd = stop.split('|')

            s = Stop.new(sd[2],sd[0],sd[1],sd[3].chop,sd[4].split("<br>"))
            route.stops << s
        end
    end

    def BustedJson.parse_busses(res, route)
        busses = res[2].split(';')
        busses.each do |bus|
            bd = bus.split('|')
            b = Bus.new(bd[0],bd[1],bd[3].split('<br>')[0],bd[3].split('<br>')[1])
            route.busses << b
        end
    end
end
  
