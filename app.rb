require "sinatra"
require "sinatra/reloader"

require "http"

# render all the currencies 

get("/") do

  api_url = "https://api.exchangerate.host/list?access_key=#{ENV["EXCHANGE_RATE_KEY"]}"

  raw_data = HTTP.get(api_url) 
  
  raw_data_string = raw_data.to_s

  parsed_data = JSON.parse(raw_data_string)

  @symbols = parsed_data.fetch("currencies")

  erb(:homepage)
end


# this page will render the currency you choose to all the other currencys 
get "/:from_currency" do
  @from_currency = params[:from_currency]
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV["EXCHANGE_RATE_KEY"]}"

  raw_data = HTTP.get(api_url) 
  
  raw_data_string = raw_data.to_s

  parsed_data = JSON.parse(raw_data_string)

  @symbols = parsed_data.fetch("currencies")

  erb(:conversion_page)
end


get "/:from_currency/:to_currency" do
  @from_currency = params[:from_currency]
  @to_currency = params[:to_currency]
  
  api_url = "https://api.exchangerate.host/convert?access_key=#{ENV["EXCHANGE_RATE_KEY"]}&from=#{@from_currency}&to=#{@to_currency}&amount=1"
  raw_data = HTTP.get(api_url)
  parsed_data = JSON.parse(raw_data.to_s)
  @conversion_rate = parsed_data.fetch("result")
  
  # Calculate the converted amount
  @converted_amount = 1 * @conversion_rate
  
  erb(:results)
end
