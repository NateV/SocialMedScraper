require 'sinatra'
require_relative '../SocialMediaTracker/lib/SocialMediaScraper.rb'

get '/' do
  erb :index
end

get '/stats.csv' do 
  scraper = Scraper.new
  scraper.scrape
end