class ParsersController < ApplicationController
  def show
    @parser = HistoricalPrice.select(:month, :year, :open_price, :highest_price, :lowest_price, :volume, :close_price).where(year: params[:year], ticker: params[:ticker])

    if @parser.present? == false
      valid_tickers =  ["PETR4","VALE3","MGLU3"]
      if params[:ticker].in?(valid_tickers) && params[:year].present?
        @parser = Parser.new(archive_path: "#{params[:ticker]}.SA.csv", year: params[:year]).make
        
        @parser.each do |parsed|
          next unless parsed[1].present?
          month = parsed[0].to_s
          data = parsed[1].map{|x| x.to_h}

          @historical_price = HistoricalPrice.new(ticker: params[:ticker], year: params[:year], month: month, 
            open_price: data[0][:open].to_f, highest_price: data[4][:highest_price].to_f, 
            lowest_price: data[3][:lowest_price].to_f, volume: data[2][:volume].to_i, close_price: data[1][:close].to_f)
          @historical_price.save
        end
        render json: {result: @parser}, status: 200
      else
        render json: {result: "ticker not found"}, status: 404
      end
    else
      render json: {result: @parser}, status: 200
    end
  end
end
