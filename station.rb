# Copyright: Kit Plummer
# http://creativecommons.org/licenses/by-sa/3.0/us/

class Station
    attr_accessor :name, :lat, :lng, :direction, :destination, :departures

    def initialize(name, lat, lng, direction, departures = []) 
        @name = name
        @lat = lat
        @lng = lng
        @direction = direction
        @departures = departures
    end

    def to_json(*a)
        {
            "Station" => { "name" => @name,
                        "lat" => @lat,
                        "lng" => @lng,
                        "direction" => @direction,
                        "departures" => @departures }
        }.to_json(*a)
    end

end
