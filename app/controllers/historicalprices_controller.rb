class HistoricalpricesController < ApplicationController
  VALID_TICKETS = ["PETR4","VALE3","MGLU3"].freeze
  before_action :set_parser, only: [:show]

  def show
    return render json: historicalprices_serializer, status: 200 if @parser.present?
    return render json: {result: "ticker not found"}, status: 404 unless valid_params?

    @parser = Parser.new(archive_path: "#{params[:ticker]}.SA.csv", ticker: parser_params[:ticker], year: parser_params[:year]).call

    data = @parser.map{|historical| historical[1][0]}
    HistoricalPrice.insert_all(data)

    render json: parser_serializer, status: 200
  end

  private
    def parser_params
      params.require(:historicalprice).permit(:year, :ticker)
    end

    def set_parser
      @parser = HistoricalPrice.where(parser_params)
    end

    def valid_params?
      parser_params[:ticker].in?(VALID_TICKETS) && parser_params[:year].present?
    end

    def historicalprices_serializer
      @parser.as_json(except: [:id, :created_at, :updated_at])
    end

    def parser_serializer
      @parser.map{|historical| historical[1][0]}
    end
end