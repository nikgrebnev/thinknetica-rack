require_relative 'responce_worker'
require_relative 'time_formatter'

class App

  def call(env)
    @path = env["REQUEST_PATH"]
    @query = env["QUERY_STRING"]

    if @path != '/time'
      return Rack::Response.new('', 404, {})
    end

      worker = ResponceWorker.new(@query)

    if worker.response_valid?
      Rack::Response.new(worker.body, 200, headers)
    else
      Rack::Response.new("Unknown time format [#{worker.body}]", 400, headers)
    end
  end

  private

  def headers
    { 'Content-Type' => 'text/plain' }
  end
end