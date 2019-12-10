class TimeFormatter

  REPLACE_DATA = {
      'year' => '%Y',
      'month' => '%m',
      'day' => '%d',
      'hour' => '%H',
      'minute' => '%M',
      'second' => '%S'
  }

  def initialize(str)
    @parse_string = str
    @unknown_attributes = []
  end

  def parse_query(str)
    REPLACE_DATA.each do |key,val|
      str.gsub!(key,val)
    end
    str.gsub!(',','-')
    str
  end

  def query_valid?
    return false if @parse_string[0..6] != "format="
    @parse_string = @parse_string[7..-1]
    @parse_string.split(',').each do |key|
      @unknown_attributes << key if !REPLACE_DATA.include?(key.strip)
    end
    return false unless @unknown_attributes.empty?
    true
  end

  def body_error
    @unknown_attributes.join(',')
  end

  def body_valid
    Time.now.to_datetime.strftime(parse_query(@parse_string))
  end
end