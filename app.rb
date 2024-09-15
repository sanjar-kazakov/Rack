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

      if time_formatter.unknown_formats.any?
        test_method(400, "Unknown time format [#{time_formatter.unknown_formats.join(', ')}]")
      else
        test_method(200, time_formatter.time)
      end
    else
      test_method(404, 'Not Found')
    end


  end

  def test_method(status, body)
    response = Rack::Response.new
      response.status = status
      response.write(body)
      response.headers['Content-Type'] = 'text/plain'

    response.finish
  end
end