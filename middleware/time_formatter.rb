class TimeFormatter
  SUPPORTED_FORMATS = { 'year' => '%Y', 'month' => '%m', 'day' => '%d', 'hour' => '%H', 'minute' => '%M',
                        'second' => '%S' }.freeze
  def initialize(format)
    @format = format.split(',')
  end

  def time
    time_format = @format.map { |part| SUPPORTED_FORMATS[part] }.join('-')
    Time.now.strftime(time_format)
  end

  def unknown_formats
    @format - SUPPORTED_FORMATS.keys
  end

  def response
    response = Rack::Response.new

    if unknown_formats.any?
      response.status = 400
      response.headers['Content-Type'] = 'text/plain'
      response.write("Unknown time format [#{unknown_formats.join(', ')}]")
    else
      response.status = 200
      response.header['Content-Type'] = 'text/plain'
      response.write(time)
    end

    response.finish
  end
end
