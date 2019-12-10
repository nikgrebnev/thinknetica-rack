require_relative 'responce_worker'
require_relative 'time_formatter'

class App

  DEFAULT_PATH = '/time'

  def initialize
  end

  def call(env)
    @body = []
    @path = env["REQUEST_PATH"]
    @query = env["QUERY_STRING"]

    return respond_404 unless path_valid?

    worker = ResponceWorker.new(@query)
    responce_valid, @responce_body = worker.worker

    return respond_400 unless responce_valid


    @body << @responce_body

    [ status, headers, body ]
  end

  private

  def body
    @body
  end

  def status
    200
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def respond_400
    @body << "Unknown time format [#{@responce_body}]"
    [ 400, headers, body ]
  end

  def respond_404
    [ 404, {}, body ]
  end

  def path_valid?
    @path == DEFAULT_PATH
  end
end