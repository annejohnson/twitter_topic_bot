require 'twitter'
require 'forwardable'

class TwitterTopicBot
  class ApiClient
    extend Forwardable

    MAX_TWEET_LENGTH = 140

    def_delegators :twitter_client,
                   :favorite,
                   :following,
                   :followers

    def initialize(credentials)
      @credentials = Hash[credentials.map { |k, v| [k.to_s, v] }]
      @tweet_filterer = TwitterTopicBot::TweetFilterer.new
      @max_num_tweets_per_query = 60
    end

    def max_tweet_length
      MAX_TWEET_LENGTH
    end

    def tweet(str, options = {})
      twitter_client.update(str, options)
    end

    def retweet(*tweets)
      twitter_client.retweet(*tweets.map(&:id))
    rescue Twitter::Error::Forbidden
      false
    end

    def follow(*users)
      twitter_client.follow(*users.map(&:id))
    end

    def search_recent_tweets(query_str)
      filter_tweets(
        twitter_client.search(
          query_str,
          result_type: 'recent'
        ).take(max_num_tweets_per_query)
      )
    end

    def mentions
      filter_tweets(
        twitter_client.mentions_timeline,
        allow_links: false
      )
    end

    def tweets
      twitter_client.user_timeline(
        username,
        count: max_num_tweets_per_query
      )
    end

    def replies
      tweets.select do |tweet|
        tweet.in_reply_to_status_id.to_s.match(/\d+/)
      end
    end

    def username
      credentials['username']
    end

    private

    attr_reader :tweet_filterer,
                :credentials,
                :max_num_tweets_per_query

    def filter_tweets(tweets, allow_links: true)
      allowed_languages = ['en']
      tweets.select do |tweet|
        allowed_languages.include?(tweet.lang) &&
          tweet_filterer.acceptable_tweet?(tweet.text, allow_links: allow_links)
      end
    end

    def twitter_client
      @twitter_client ||= Twitter::REST::Client.new do |config|
        config.consumer_key = credentials['consumer_key']
        config.consumer_secret = credentials['consumer_secret']
        config.access_token = credentials['access_token']
        config.access_token_secret = credentials['access_token_secret']
      end
    end
  end
end
