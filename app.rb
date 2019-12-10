require_relative 'time_formatter'

class App

  DEFAULT_PATH = '/time'

  def initialize
  end

  def call(env)
    @body = []
    @path = env["REQUEST_PATH"]
    @query = env["QUERY_STRING"]

    @formatter = TimeFormatter.new(@query)

    return respond_404 unless path_valid?
    return respond_400 unless @formatter.query_valid?

    @body << @formatter.body_valid

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
    @body << "Unknown time format [#{@formatter.body_error}]"
    [ 400, headers, body ]
  end

  def respond_404
    [ 404, {}, body ]
  end

  def path_valid?
    @path == DEFAULT_PATH
  end
end