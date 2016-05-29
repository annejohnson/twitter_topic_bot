require 'twitter_topic_bot'

class ArtContentPreparer
  def topic_string
    ['#painting', '#watercolor'].sample
  end

  def prepare_tweet
    %q{If you hear a voice within you say 'you cannot paint,' then by all means paint, and that voice will be silenced. -Vincent Van Gogh}
  end

  def prepare_reply(tweet_to_reply_to, user_to_reply_to)
    "@#{user_to_reply_to}, thank you for tweeting about art!"
  end
end

content_preparer = ArtContentPreparer.new

credentials = {
  username: '<Your bot\'s Twitter username (without the @ sign)>',
  consumer_key: '<Your consumer key>',
  consumer_secret: '<Your consumer secret>',
  access_token: '<Your access token>',
  access_token_secret: '<Your access token secret>'
}

bot = TwitterTopicBot.new(content_preparer, credentials)

bot.schedule do |schedule|
  schedule.every('30m') { bot.tweet }
  schedule.every('3h') { bot.follow_someone }
  schedule.every('1d') { bot.reply_to_someone }
  schedule.cron('15,45 * * * *') { bot.retweet_someone }
end

loop { sleep 1 }
