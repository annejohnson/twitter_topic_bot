require 'spec_helper'

describe TwitterTopicBot do
  subject do
    described_class.new(content_preparer, twitter_api_credentials)
  end

  let(:api_client) { twitter_rest_client }

  before :each do
    expect(Twitter::REST::Client).to receive(:new).
      and_return(api_client)
  end

  describe '#tweet' do
    it 'tweets about the topic' do
      expect(api_client).to receive(:update).
        with(content_preparer.prepare_tweet, any_args)
      subject.tweet
    end
  end

  describe '#retweet_someone' do
    let(:topic_tweet) do
      twitter_tweet(substring: content_preparer.topic_string)
    end

    before :each do
      expect(api_client).to receive(:search).
        with(content_preparer.topic_string, any_args).
        and_return([topic_tweet])
    end

    it 'retweets someone who has tweeted about the topic' do
      expect(api_client).to receive(:retweet).
        with(topic_tweet.id)
      subject.retweet_someone
    end
  end

  describe '#follow_someone' do
    let(:topic_tweet) do
      twitter_tweet(substring: content_preparer.topic_string)
    end

    before :each do
      expect(api_client).to receive(:search).
        with(content_preparer.topic_string, any_args).
        and_return([topic_tweet])
    end

    it 'follows someone who has tweeted about the topic' do
      expect(api_client).to receive(:follow).
        with(topic_tweet.user.id)
      subject.follow_someone
    end
  end

  describe '#retweet_mentions' do
    let(:mention_tweets) do
      twitter_tweet_collection(substring: '@twittertopicbot')
    end

    before :each do
      expect(api_client).to receive(:mentions_timeline).
        and_return(mention_tweets)
    end

    it 'retweets mentions' do
      expect(api_client).to receive(:retweet).
        with(kind_of(Numeric)).
        exactly(mention_tweets.size).times
      subject.retweet_mentions
    end
  end

  describe '#reply_to_someone' do
    let(:topic_tweet) do
      twitter_tweet(
        substring: content_preparer.topic_string,
        retweet: false
      )
    end

    before :each do
      expect(api_client).to receive(:search).
        with(content_preparer.topic_string, any_args).
        and_return([topic_tweet])
    end

    it 'replies to a tweet about the topic' do
      expect(api_client).to receive(:update).
        with(
          content_preparer.prepare_reply(
            topic_tweet.text,
            topic_tweet.user.screen_name
          ),
          hash_including(in_reply_to_status_id: topic_tweet.id)
        )
      subject.reply_to_someone
    end
  end

  describe '#follow_followers' do
    let(:already_followed_followers) { api_client.following }
    let(:not_yet_followed_followers) do
      api_client.followers.reject do |follower|
        already_followed_followers.map(&:id).include?(follower.id)
      end
    end

    it 'follows its not-yet-followed followers' do
      expect(api_client).to receive(:follow).
        with(kind_of(Numeric)).
        exactly(not_yet_followed_followers.size).times
      subject.follow_followers
    end
  end
end
