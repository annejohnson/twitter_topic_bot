class TwitterTopicBot
  class TweetFilterer
    def initialize(options = {})
      @max_num_mentions = options.fetch(:max_num_mentions, 1)
      @max_num_hashtags = options.fetch(:max_num_hashtags, 3)
    end

    def acceptable_tweet?(tweet_str, allow_links: true)
      return false if is_spammy_tweet?(tweet_str) ||
                      is_sketchy_tweet?(tweet_str) ||
                      has_too_many_mentions?(tweet_str) ||
                      has_too_many_hashtags?(tweet_str)

      allow_links || !contains_link?(tweet_str)
    end

    private

    attr_reader :max_num_mentions,
                :max_num_hashtags

    def is_spammy_tweet?(tweet_str)
      contains_link?(tweet_str) &&
        tweet_str.match(/(buy)|(e-?book)|(order)|(press)/i)
    end

    def is_sketchy_tweet?(tweet_str)
      tweet_str.match(/(fuck)|(fetish)|(ass)|(gamergate)|(shit)|(bitch)|(cunt)|(rape)/i)
    end

    def has_too_many_mentions?(tweet_str)
      num_mentions = tweet_str.split.count do |word|
        word.start_with?('@')
      end
      num_mentions > max_num_mentions
    end

    def has_too_many_hashtags?(tweet_str)
      num_hashtags = tweet_str.split.count do |word|
        word.start_with?('#')
      end
      num_hashtags > max_num_hashtags
    end

    def contains_link?(tweet_str)
      tweet_str.match(/http:\/\//i)
    end
  end
end
