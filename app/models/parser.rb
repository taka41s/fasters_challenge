class Parser
  attr_accessor :file_path, :items, :year, :ticker
  def initialize(options = {})
    @archive_path = options[:archive_path]
    @items = []
    @year = options[:year]
  end

  def make
    read_file
    organize_tuples
    set_data_to_display_in_api
  end

  def filter_by_year(year)
    filtered =[]

    items.map{|item| filtered << item if item[:date].year == year.to_i}

    filtered
  end

  def organize_month_tuples
    filtered = {january:[], february:[], march:[], april:[], may:[], june:[], july:[], august:[], september:[], october:[], november:[], december:[]}
    filter_by_year(year).each do |row|
      case row.present?

      when row[:date].month == 1
       filtered[:january] << row
      when row[:date].month == 2
        filtered[:february] << row
      when row[:date].month == 3
        filtered[:march] << row
      when row[:date].month == 4
        filtered[:april] << row
      when row[:date].month == 5
        filtered[:may] << row
      when row[:date].month == 6
        filtered[:june] << row
      when row[:date].month == 7
        filtered[:july] << row
      when row[:date].month == 8
        filtered[:august] << row
      when row[:date].month == 9
        filtered[:september] << row
      when row[:date].month == 10
        filtered[:october] << row
      when row[:date].month == 11
        filtered[:november] << row
      when row[:date].month == 12
        filtered[:december] << row
      end
    end
    filtered
  end

  def set_data_to_display_in_api
    data = {january:[], february:[], march:[], april:[], may:[], june:[], july:[], august:[], september:[], october:[], november:[], december:[]}
    volume = 0
    organize_month_tuples[:january].each do |tuple|
      volume = tuple[:volume].to_i + volume
    end

    months_initials.each do |month|
      next unless month_exist?(month)
      data[month] << {
        month: month,
        year: year.to_i,
        open_price: organize_month_tuples[month]&.first[:open].to_f, 
        close_price: organize_month_tuples[month].last[:close].to_f, volume: volume, 
        lowest_price: organize_month_tuples[month].map{|row| row[:low].to_f}.min,
        highest_price: organize_month_tuples[month].map{|row| row[:high].to_f}.max
      }
    end

    data
  end

  def month_exist?(month)
    organize_month_tuples[month].present?
  end

  def months_initials
    organize_month_tuples.map(&:first)
  end

  def organize_tuples
    @archive_tuples.each do |row|
      set_headers_and_data(row)
    end
  end

  def set_headers_and_data(row)
    return true if @items << {date: Date.parse(row['Date']), open: row['Open'], high: row['High'], low: row['Low'], close: row['Close'], Adj_close: row['Adj Close'], volume: row['Volume']}
  end

  def read_file
    @archive_tuples = CSV.read(@archive_path, headers: true)
  end
end