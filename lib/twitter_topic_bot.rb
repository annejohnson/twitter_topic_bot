require 'twitter'
require 'twitter_topic_bot/version'
require 'twitter_topic_bot/api_client'
require 'twitter_topic_bot/tweet_filterer'

class TwitterTopicBot
  def initialize(content_preparer, credentials)
    @content_preparer = content_preparer
    @api_client = TwitterTopicBot::ApiClient.new(credentials)
  end

  def tweet
    api_client.tweet(
      content_preparer.prepare_tweet
    )
  end

  def retweet_someone
    api_client.retweet(tweet_to_retweet)
  end

  def follow_someone
    api_client.follow(user_to_follow)
  end

  def retweet_mentions
    api_client.retweet *api_client.mentions
  end

  def reply_to_someone
    tweet = tweet_to_reply_to
    reply = content_preparer.prepare_reply(
              tweet.text,
              tweet.user.screen_name
            )

    api_client.tweet(
      reply,
      in_reply_to_status_id: tweet.id
    )
  end

  def follow_followers
    api_client.follow *api_client.followers
  end

  private

  attr_reader :content_preparer,
              :api_client

  def tweet_to_retweet
    get_topic_tweets.max_by(&:favorite_count)
  end

  def user_to_follow
    get_topic_tweets.sample.user
  end

  def tweet_to_reply_to
    tweet_ids_already_replied_to = api_client.replies.map(&:in_reply_to_status_id)

    get_topic_tweets.reject do |tweet|
      tweet.retweet? || tweet_ids_already_replied_to.include?(tweet.id)
    end.sample
  end

  def get_topic_tweets
    api_client.search_recent_tweets(
      content_preparer.topic_string
    )
  end
end
