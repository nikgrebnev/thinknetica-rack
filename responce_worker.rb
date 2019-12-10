class ResponceWorker

  attr_reader :valid

  def initialize(str)
    @query = str
    @unknown_attributes = []
    @formatter = TimeFormatter.new

    @valid = check_query
  end

  def body
    @valid ? body_valid : body_error
  end

  private

  def check_query
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