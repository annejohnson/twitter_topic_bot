class ContentPreparer
  def prepare_tweet
    'Hello, Twitterverse!'
  end

  def prepare_reply(tweet_to_reply_to, user_to_reply_to)
    "Thanks for tweeting, @#{user_to_reply_to}!"
  end

  def topic_string
    '#currentEvents'
  end
end

def content_preparer
  ContentPreparer.new
end
