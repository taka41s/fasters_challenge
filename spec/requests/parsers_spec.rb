require 'rails_helper'

RSpec.describe "Parsers", type: :request do
  describe "POST /list" do
    it 'requests to list ticker by year' do
      headers = {"Content-Type" => "application/json"}
      get "/list", params: {year: "2012", ticker: "PETR4"}, :headers => headers

      expect(response.content_type).to eq("application/json; charset=utf-8")
    end

    it 'requests to list ticker by year' do
      headers = {"Content-Type" => "application/json"}
      get "/list", params: {year: "2012", ticker: "MGLU3"}, :headers => headers

      expect(response.content_type).to eq("application/json; charset=utf-8")
    end

    it 'requests to list and checks if return a 200 http status' do
      headers = {"Content-Type" => "application/json"}
      get "/list", params:{ticker: "VALE3", year: "2000"}, :headers => headers
      expect(response.status).to eq(200)
    end

    it 'requests to list and checks if return a 200 http status' do
      headers = {"Content-Type" => "application/json"}
      get "/list", params:{ticker: "MGLU3", year: "2012"}, :headers => headers
      expect(response.status).to eq(200)
    end

    it 'requests to list and checks if return a 200 http status' do
      headers = {"Content-Type" => "application/json"}
      get "/list", params:{ticker: "PETR4", year: "2012"}, :headers => headers
      expect(response.status).to eq(200)
    end

    it 'requests to list and checks if return a 404 http status if ticker doesnt exist' do
      headers = {"Content-Type" => "application/json"}
      get "/list", params: {year: "2012", ticker: "that ticker dont exist"}, :headers => headers

      expect(response.status).to eq(404)
    end
  end
end
