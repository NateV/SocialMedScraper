require 'rubygems'
require 'net/http'
require 'uri'
require 'date'
require 'json'
require 'oauth'
require 'csv'
#require './secrets.rb' if File.exists?('secrets.rb')
require './env.rb' if File.exists?('env.rb')


class Scraper

  def initialize(*args)
    if args.length==0 then
      @organizations =   JSON.parse('[{
      "organization": "NYCLU",
      "facebook_screen_name": "NewYorkCivilLibertiesUnion",
      "twitter_screen_name": "NYCLU"
    },{
      "organization": "Center for Constitutional Rights",
      "facebook_screen_name": "CenterforConstitutionalRights",
      "twitter_screen_name": "theCCR"
    },{
      "organization": "The Brennan Center",
      "facebook_screen_name": "BrennanCenter",
      "twitter_screen_name": "BrennanCenter"
    },{
      "organization": "NAACP_LDF",
      "facebook_screen_name": "naacpldf",
      "twitter_screen_name": "NAACP_LDF"
    },{
      "organization": "ACLU",
      "facebook_screen_name": "aclu.nationwide",
      "twitter_screen_name": "ACLU"
    },{
      "organization": "ACLU_SoCal",
      "facebook_screen_name": "ACLU.SoCal",
      "twitter_screen_name": "ACLU_SoCal"
    },{
      "organization": "ACLU_WA",
      "facebook_screen_name": "acluwa",
      "twitter_screen_name": "ACLU_WA"
    },{
      "organization": "ACLUUtah",
      "facebook_screen_name": "aclu.utah",
      "twitter_screen_name": "acluutah"
    },{
      "organization": "National Action",
      "facebook_screen_name": "nationalactionnetwork",
      "twitter_screen_name": "nationalaction"
    },{
      "organization": "SPL Center",
      "facebook_screen_name": "SPLCenter",
      "twitter_screen_name": "splcenter"
    },{
      "organization": "Lambda Legal",
      "facebook_screen_name": "lambdalegal",
      "twitter_screen_name": "LambdaLegal"
    },{
      "organization": "Latino Justice",
      "facebook_screen_name": "latinojustice",
      "twitter_screen_name": "latinojustice"
    },{
      "organization": "CivilRights.org",
      "facebook_screen_name": "civilandhumanrights",
      "twitter_screen_name": "civilrightsorg"
    }
]')
    else
      @organizations = JSON.parse(args[0])
    end
  end# of initialize

  #for twitter:
  # Exchange your oauth_token and oauth_token_secret for an AccessToken instance.
  def prepare_access_token(oauth_token, oauth_token_secret)
    consumer = OAuth::Consumer.new(ENV['TWITTER_API_KEY'],ENV['TWITTER_API_SECRET'],
       { :site => "https://api.twitter.com",
         :scheme=> :header 
       })
  
    # now create the access token object from passed values
    token_hash = { :oauth_token => oauth_token,
  				 :oauth_token_secret => oauth_token_secret}
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash)
    puts access_token
    access_token
  end# of prepare_access_token

#   def organizations
# 	JSON.parse(File.open(ARGV[0]).read)
# 	
#   end# of #organizations
  
  def facebook_scrape (facebook_screen_name)
    puts "Facebook scrape!"
    uri = URI.parse("http://graph.facebook.com/#{facebook_screen_name}")
    response = JSON.parse(Net::HTTP.get(uri))

    {facebook_checkins: response["checkins"],
     facebook_likes: response["likes"],
     facebook_talking_about_count: response["talking_about_count"],
     facebook_were_here_count: response["were_here_count"]}
  end# of facebook_scrape
  
  def twitter_scrape (twitter_screen_name)
    puts "Scraping twitter!"
    access_token = prepare_access_token(ENV['TWITTER_ACCESS_TOKEN'],ENV['TWITTER_ACCESS_TOKEN_SECRET'])
	response = access_token.request(:get, "https://api.twitter.com/1.1/users/show.json?screen_name=#{twitter_screen_name}")
	response = JSON.parse(response.body)
    {twitter_followers_count: response["followers_count"],
     twitter_friends_count: response["friends_count"],
     twitter_listed_count: response["listed_count"],
     twitter_favourites_count: response["favourites_count"],
     twitter_statuses_count: response["statuses_count"] }
  end# of #twitter_scrape
  
  def print (results)
    headers = results[0].keys
    CSV.open("../scrapes/SMS-#{date.month}-#{date.day}-#{date.year}.csv","w") do |csv|
      csv << headers
      results.each do |hash|
        csv << CSV::Row.new(hash.keys, hash.values)
      end
    end
  end# of print
  
  def self.as_csv(scrapes)
    result = ""
    headers = scrapes[0].keys
    headers.each_with_index do |key, i|
      if i<(headers.count-1) then
        result += "#{key}, "
      else
        result += "#{key} \n"
      end
    end
    scrapes.each do |row|
      row.values.each_with_index do |value, i|
        if i<(row.values.count-1) then
          result += "#{value}, "
        else
          result += "#{value} \n"
        end
      end
    end
    result
  end# of as_csv
  
  def scrape
    date = Date.today
    #puts organizations
    results = @organizations.map do |organization|
      output = {date: "#{date.month}-#{date.day}-#{date.year}",
      			organization: organization["organization"]}
      output.merge! facebook_scrape(organization["facebook_screen_name"])
      output.merge! twitter_scrape(organization["twitter_screen_name"])
    end
    puts results
    puts "and now to csv"
    
    #print(results)
    results
    
  end# of #scrape

end# of class

# scraper = Scraper.new
# scraper.scrape