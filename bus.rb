class Bus
    attr_accessor :lat, :lng, :direction, :destination

    def initialize(lat, lng, direction, destination)
        @lat = lat
        @lng = lng
        @direction = direction
        @destination = destination
    end

    def to_json(*a)
        {
            "Bus" => { "lat" => @lat,
                "lng" => @lng,
                "direction" => @direction,
                "destination" => @destination}
        }.to_json(*a)
    end
end
