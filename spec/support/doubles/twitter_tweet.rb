def twitter_tweet(options = {})
  tweet = instance_double(Twitter::Tweet)
  allow(tweet).to receive(:id).
    and_return(random_integer)
  allow(tweet).to receive(:favorite_count).
    and_return(random_integer)
  allow(tweet).to receive(:lang).
    and_return('en')
  tweet_text = [
    random_string,
    options.fetch(:substring, ''),
    random_string
  ].shuffle.join
  allow(tweet).to receive(:text).
    and_return(tweet_text)
  allow(tweet).to receive(:in_reply_to_status_id).
    and_return([nil, random_integer].sample)
  allow(tweet).to receive(:retweet?).
    and_return(
      options.fetch(:retweet, [true, false].sample)
    )
  allow(tweet).to receive(:user).
    and_return(twitter_user)

  tweet
end

def twitter_tweet_collection(options = {})
  [0..random_integer].to_a.map { |_| twitter_tweet(options) }
end
