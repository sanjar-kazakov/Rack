require_relative 'middleware/time_formatter'
require 'byebug'

class App
  def call(env)
    req = Rack::Request.new(env)
    format = req.params['format']

    build_response(req.path, format)
  end

  def build_response(path, format)

    if path == '/time' && format
      time_formatter = TimeFormatter.new(format)

      if time_formatter.valid?
        send_response(400, "Unknown time format [#{time_formatter.unknown_formats.join(', ')}]")
      else
        send_response(200, time_formatter.time)
      end
    else
      send_response(404, 'Not Found')
    end


  end

  def send_response(status, body)
    response = Rack::Response.new
    response.status = status
    response.write(body)
    response.headers['Content-Type'] = 'text/plain'

    response.finish
  end
end