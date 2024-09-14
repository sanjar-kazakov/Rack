require_relative 'middleware/time_formatter'

class App
  def call(env)
    req = Rack::Request.new(env)
    format = req.params['format']

    if req.path == "/time" && format
      time_formatter = TimeFormatter.new(format)

      time_formatter.response
    else
      res = Rack::Response.new
      res.status = 404
      res.header['Content-Type'] = 'text/plain'
      res.write('Not Found')

      res.finish
    end
  end
end
