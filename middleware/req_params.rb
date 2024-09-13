class RequestParams
  SUPPORTED_FORMATS = %w[year month day hour minute second].freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    format = req.params["format"]

    if req.path == "/time" && format
      time_parts = current_time_parts

      format_keys = format.split(',')
      unknown_formats = format_keys - SUPPORTED_FORMATS

      if unknown_formats.any?
        response_body = "Unknown time format [#{unknown_formats.join(', ')}]"
        return [400, { "Content-Type" => "text/plain" }, [response_body]]
      end

      date_keys = %w[year month day]
      time_keys = %w[hour minute second]

      date_parts = date_keys.select { |key| format_keys.include?(key) }
      time_parts_keys = time_keys.select { |key| format_keys.include?(key) }

      date_response = date_parts.map { |part| time_parts[part] }.join("-") unless date_parts.empty?
      time_response = time_parts_keys.map { |part| time_parts[part] }.join(":") unless time_parts_keys.empty?

      response_body = [date_response, time_response].reject(&:nil?).join(" ")
      [200, { "Content-Type" => "text/plain" }, [response_body]]

    else
      return [404, { "Content-Type" => "text/plain" }, ["Not Found"]]
    end
  end

  private

  def current_time_parts
    current_time = Time.now
    {
      "year"   => current_time.strftime("%Y"),
      "month"  => current_time.strftime("%m"),
      "day"    => current_time.strftime("%d"),
      "hour"   => current_time.strftime("%H"),
      "minute" => current_time.strftime("%M"),
      "second" => current_time.strftime("%S")
    }
  end
end
