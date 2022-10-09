class ParsersController < ApplicationController
  def show
    @parser = HistoricalPrice.select(:month, :year, :open_price, :highest_price, :lowest_price, :volume, :close_price, :id).
      where(year: params[:year], ticker: params[:ticker])

    if @parser.present? == false
      valid_tickers =  ["PETR4","VALE3","MGLU3"]

      if params[:ticker].in?(valid_tickers) && params[:year].present?
        @parser = Parser.new(archive_path: "#{params[:ticker]}.SA.csv", year: params[:year]).make

        @parser.each do |parsed|
          next unless parsed[1].present?
          month = parsed[0].to_s
          data = parsed[1].map{|x| x.to_h}.first.merge(ticker: params[:ticker])
          @historical_price = HistoricalPrice.new(data)
          @historical_price.save
        end

        render json: {result: @parser.to_a.map{|x| x[1][0]}}, status: 200
      else
        render json: {result: "ticker not found"}, status: 404
      end
    else
      render json: {result: @parser}, status: 200
    end
  end
end
