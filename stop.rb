# Copyright: Kit Plummer
# http://creativecommons.org/licenses/by-sa/3.0/us/

class Stop
    attr_accessor :name, :lat, :lng, :direction, :departures

    def initialize(name, lat, lng, direction, departures = []) 
        @name = name
        @lat = lat
        @lng = lng
        @direction = direction
        @departures = departures
    end

    def to_json(*a)
        {
            "Spot" => { "name" => @name,
                    "lat" => @lat,
                    "lng" => @lng,
                    "direction" => @direction,
                    "departures" => @departures }
        }.to_json(*a)
    end
end
