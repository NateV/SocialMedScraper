require 'OAuth'

# Exchange your oauth_token and oauth_token_secret for an AccessToken instance.
def prepare_access_token(oauth_token, oauth_token_secret)
  consumer = OAuth::Consumer.new("k0aEct0Ld2tqbrMhNuYF8H3FP","u8fYNu0QwoLLfzPasrtlahW3WLM4d8Sn2DTeliMNyi4KlKU3QL", 
     { :site => "https://api.twitter.com",
       :scheme=> :header 
     })
  
  # now create the access token object from passed values
  token_hash = { :oauth_token => oauth_token,
  				 :oauth_token_secret => oauth_token_secret}
  access_token = OAuth::AccessToken.from_hash(consumer, token_hash)
  puts access_token
  access_token
end

access_token = prepare_access_token("5881422-y6oNSaeBDY7XazqwQwrDuiRA1qiWT9i3O9WqFa8Ae0","lTfHOXJDIE09MiU9dF8Dyjj9XTGO03dJRNJwphXddOWAa")
response = access_token.request(:get, "https://api.twitter.com/1.1/users/show.json?screen_name=NYCLU")

puts response.body