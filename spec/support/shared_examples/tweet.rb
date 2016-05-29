shared_examples 'a tweet' do
  let(:max_num_characters) { 140 }

  it 'contains no more than the allowed number of characters' do
    expect(tweet.length <= max_num_characters).to be_truthy
  end
end
