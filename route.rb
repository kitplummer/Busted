class Route
    attr_accessor :id, :stations, :stops, :busses, :requested 

    def initialize(id, requested = Time.now, stations = [], stops = [], busses = [])
        @requested = requested
        @id = id
        @stations = stations
        @stops = stops
        @busses = busses
    end
    
    def to_json(*a)
        {
            "Route" => { "requested" => @requested,
                        "id" => @id,
                        "stations" => @stations,
                        "stops" => @stops,
                        "busses" => @busses }
        }.to_json(*a) 
    end
end

