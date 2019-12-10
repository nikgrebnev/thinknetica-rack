class ResponceWorker

  attr_reader :body

  def initialize(str)
    @query = str
    @unknown_attributes = []
    @formatter = TimeFormatter.new
  end

  def response_valid?
#    возвращаем 2 параметра - false если неудачно и строку с неудачными параметрами
#    или true + строку времени.
    if query_valid?
      @body = body_valid
      return true
    else
      @body = body_error
      return false
    end
  end

  def query_valid?
    return false if @query[0..6] != "format="
    @query = @query[7..-1]
    @query.split(',').each do |key|
      @unknown_attributes << key if !@formatter.include?(key.strip)
    end
    return false unless @unknown_attributes.empty?
    true
  end

  def body_error
    @unknown_attributes.join(',')
  end

  def body_valid
    @formatter.print_time(@query)
  end
end