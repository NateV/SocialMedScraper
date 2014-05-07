require 'sinatra'
require_relative '../SocialMediaTracker/lib/SocialMediaScraper.rb'

get '/' do
  erb :index
end

get '/stats.csv' do 
  scraper = Scraper.new
  @results = scraper.scrape
  @results = Scraper.as_csv(@results)
  erb :stats_csv
end