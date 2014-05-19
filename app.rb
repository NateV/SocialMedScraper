require 'sinatra'
require './SocialMediaScraper.rb'

get '/' do
  erb :index
end

get '/standardStats.csv' do 
  scraper = Scraper.new
  @results = scraper.scrape
  @results = Scraper.as_csv(@results)
  erb :stats_csv
end

get '/customOrgs' do
  erb :customOrgs
end

post '/customOrgs' do 
  organization_string = params[:organizations]
  scraper = Scraper.new(organization_string)
  @results = scraper.scrape
  @results = Scraper.as_csv(@results)
  erb :stats_csv
end