class TimeFormatter
  SUPPORTED_FORMATS = {
                        'year' => '%Y', 'month' => '%m', 'day' => '%d',
                        'hour' => '%H', 'minute' => '%M', 'second' => '%S'
                      }.freeze

  ORDERED_FORMATS = %w[year month day hour minute second].freeze

  def initialize(format)
    @format = format.split(',')
  end

  def time
    date_format = ORDERED_FORMATS.select { |part| @format.include?(part) && %w[year month day].include?(part) }
                                 .map { |part| SUPPORTED_FORMATS[part] }.compact.join('-')

    time_format = ORDERED_FORMATS.select { |part| @format.include?(part) && %w[hour minute second].include?(part) }
                                 .map { |part| SUPPORTED_FORMATS[part] }.compact.join(':')

    format_string = [date_format, time_format].reject(&:nil?).join(' ')

    Time.now.strftime(format_string)
  end

  def unknown_formats
    @format - SUPPORTED_FORMATS.keys
  end

end
