require_relative 'responce_worker'
require_relative 'time_formatter'

class App

  def call(env)
    @request = Rack::Request.new(env)
    @path = @request.path_info
    @query = @request.params['format']

    if @path != '/time'
      #если бы ниже этого if-а была логика, то надо было бы писать
      # return make_response('', 404)  тут и ниже
      make_response('Not Found', 404)
    elsif @query.nil?
      make_response("Unknown time format parameter", 400)
    else
      process_request
    end
  end

  private

  def process_request
    worker = ResponceWorker.new(@query)

    if worker.valid
      make_response(worker.body, 200)
    else
      make_response("Unknown time format [#{worker.body}]", 400)
    end
  end

  def make_response(body, status)
    Rack::Response.new(body, status, headers)
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end
end