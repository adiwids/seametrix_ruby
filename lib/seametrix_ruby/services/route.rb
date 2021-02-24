module SeametrixRuby
  module Services
    class Route
      def self.get(pairs_of_points)
        Seametrix.request('/api/GetRoutes',
                          method: :post,
                          params: build_distance_leg_params(pairs_of_points))
      end

      private

      def self.build_distance_leg_params(args)
        points = []

        args.each do |start, _end|
          start_lon, start_lat = start.split(',').map(&:strip)
          end_lon, end_lat = _end.split(',').map(&:strip)

          points << {
            'startLon' => start_lon.to_f,
            'startLat' => start_lat.to_f,
            'endLon' => end_lon.to_f,
            'endLat' => end_lat.to_f
          }
        end

        { body: points }
      end
    end
  end
end