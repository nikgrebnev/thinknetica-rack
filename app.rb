class App

  DEFAULT_PATH = '/time'
  REPLACE_DATA = {
      'year' => '%Y',
      'month' => '%m',
      'day' => '%d',
      'hour' => '%H',
      'minute' => '%M',
      'second' => '%S'
  }

  def initialize
  end

  def call(env)
    @body = []
    @path = env["REQUEST_PATH"]
    @query = env["QUERY_STRING"]

    return respond_404 unless path_valid?
    return respond_400 unless query_valid?

    @query = parse_query(@query)
    @body << Time.now.to_datetime.strftime(@query)

    [ status, headers, body ]
  end

  def status
    200
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def body
    @body
  end

  private

  def parse_query(str)
    REPLACE_DATA.each do |key,val|
      str.gsub!(key,val)
    end
    str.gsub!(',','-')
    str
  end

  def query_valid?
    return false if @query[0..6] != "format="
    @query = @query[7..-1]
    @unknown_attributes = []
    @query.split(',').each do |key|
      @unknown_attributes << key if !REPLACE_DATA.include?(key.strip)
    end
    return false unless @unknown_attributes.empty?
    true
  end

  def respond_400
    @body << "Unknown time format [#{@unknown_attributes.join(',')}]"
    [ 400, headers, body ]
  end

  def respond_404
    [ 404, {}, @body ]
  end

  def path_valid?
    @path == DEFAULT_PATH
  end
end