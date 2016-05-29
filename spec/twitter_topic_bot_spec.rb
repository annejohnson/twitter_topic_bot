require 'spec_helper'

describe TwitterTopicBot do

  let(:twitter_api_credentials) do
    {
      consumer_key: 'your_consumer_key',
      consumer_secret: 'your_consumer_secret',
      access_token: 'your_access_token',
      access_token_secret: 'your_access_token_secret'
    }
  end

  let(:content_preparer) do
    Struct.new('ContentPreparer') do
      def prepare_tweet
        'Hello, Twitterverse!'
      end

      def prepare_reply(tweet_to_reply_to, user_to_reply_to)
        'Thanks for tweeting!'
      end

      def topic_string
        '#currentEvents'
      end
    end.new
  end

  subject { described_class.new(content_preparer, twitter_api_credentials) }
  let(:api_client) { instance_double(Twitter::REST::Client) }
  let(:topic_tweet) { instance_double(Twitter::Tweet) }

  before :each do
    expect(Twitter::REST::Client).to receive(:new).
      and_return(api_client)
    allow(topic_tweet).to receive(:id).
      and_return([1..500].sample)
  end

  describe '#tweet' do
    it 'tweets' do
      expect(api_client).to receive(:update).
        with(content_preparer.prepare_tweet, any_args)
      subject.tweet
    end
  end

  describe '#retweet_someone' do
    it 'retweets someone' do
      expect(api_client).to receive(:retweet).
        with(kind_of(Numeric))
      subject.retweet_someone
    end
  end

  describe '#follow_someone' do
    it 'finds a user who has tweeted about that topic' do
      expect(api_client).to receive(:search).
        with(content_preparer.topic_string, any_args).
        and_return([topic_tweet])
      subject.follow_someone
    end

    it 'follows someone' do
      expect(api_client).to receive(:follow).
        with(kind_of(Numeric))
      subject.follow_someone
    end
  end

  describe '#retweet_mentions' do
    it 'retweets mentions' do
      expect(api_client).to receive(:retweet).
        with(kind_of(Numeric))
      subject.retweet_mentions
    end
  end

  describe '#reply_to_someone' do
    it 'finds a tweet about that topic' do
      expect(api_client).to receive(:search).
        with(content_preparer.topic_string, any_args).
        and_return([topic_tweet])
      subject.reply_to_someone
    end

    it 'replies to a tweet' do
      expect(api_client).to receive(:update).
        with(
          content_preparer.prepare_reply('hi', 'username'),
          hash_including(in_reply_to_status_id: kind_of(Numeric))
        )
      subject.reply_to_someone
    end
  end

  describe '#follow_followers' do
    it 'follows its followers' do
      expect(api_client).to receive(:follow).
        with(kind_of(Numeric))
      subject.follow_followers
    end
  end
end
