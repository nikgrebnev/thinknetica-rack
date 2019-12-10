class TimeFormatter

  REPLACE_DATA = {
      'year' => '%Y',
      'month' => '%m',
      'day' => '%d',
      'hour' => '%H',
      'minute' => '%M',
      'second' => '%S'
  }

  def parse_query(str)
    REPLACE_DATA.each do |key, val|
      str.gsub!(key, val)
    end
    str.gsub!(',','-')
    str
  end

  def include?(str)
    REPLACE_DATA.include?(str)
  end

  def print_time(str)
    parsed_query = parse_query(str)
    Time.now.to_datetime.strftime(parsed_query)
  end
end
