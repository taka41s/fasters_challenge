Rails.application.routes.draw do
  get 'list' => 'historicalprices#show'
end
