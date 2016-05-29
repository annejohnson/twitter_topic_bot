def twitter_rest_client
  client = instance_double(Twitter::REST::Client)
  allow(client).to receive(:user).with(kind_of(String)).
    and_return(twitter_user)
  allow(client).to receive(:user_timeline).with(kind_of(String), any_args).
    and_return(twitter_tweet_collection)
  [:following, :followers].each do |user_collection_method|
    allow(client).to receive(user_collection_method).
      and_return(twitter_user_collection)
  end

  client
end
