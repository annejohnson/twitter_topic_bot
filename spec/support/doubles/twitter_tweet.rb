def twitter_tweet(substring = '')
  tweet = instance_double(Twitter::Tweet)
  allow(tweet).to receive(:id).
    and_return(random_integer)
  allow(tweet).to receive(:favorite_count).
    and_return(random_integer)
  allow(tweet).to receive(:lang).
    and_return('en')
  allow(tweet).to receive(:text).
    and_return(
      [random_string, substring, random_string].shuffle.join
    )
  allow(tweet).to receive(:user).
    and_return(twitter_user)

  tweet
end
