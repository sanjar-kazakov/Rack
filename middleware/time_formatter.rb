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
    date_parts = []
    time_parts = []

    ORDERED_FORMATS.each do |part|
      next unless @format.include?(part)

      if %w[year month day].include?(part)
        date_parts << SUPPORTED_FORMATS[part]
      elsif %w[hour minute second].include?(part)
        time_parts << SUPPORTED_FORMATS[part]
      end
    end

    date_format = date_parts.join('-')
    time_format = time_parts.join(':')

    format_string = [date_format, time_format].reject(&:nil?).join(' ')

    Time.now.strftime(format_string)
  end

  def unknown_formats
    @format - SUPPORTED_FORMATS.keys
  end

  def valid?
    unknown_formats.any?
  end
end