class ResponceWorker

  def initialize(str)
    @query = str
    @unknown_attributes = []
    @formatter = TimeFormatter.new
  end

  def worker
#    возвращаем 2 параметра - false если неудачно и строку с неудачными параметрами
#    или true + строку времени.
    if query_valid?
      return true, body_valid
    else
      return false, body_error
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