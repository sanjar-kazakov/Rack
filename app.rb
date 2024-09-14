require_relative 'middleware/time_formatter'
require 'byebug'

class App
  def call(env)
    req = Rack::Request.new(env)
    format = req.params['format']

    build_response(req.path, format)
  end

  def build_response(path, format)
    response = Rack::Response.new

    if path == '/time' && format
      time_formatter = TimeFormatter.new(format)

      if time_formatter.unknown_formats.any?
        response.status = 400
        response.headers['Content-Type'] = 'text/plain'
        response.write("Unknown time format [#{time_formatter.unknown_formats.join(', ')}]")
      else
        response.status = 200
        response.header['Content-Type'] = 'text/plain'
        response.write(time_formatter.time)
      end
    else
      response.status = 404
      response.header['Content-Type'] = 'text/plain'
      response.write('Not Found')
    end

    response.finish
  end
end