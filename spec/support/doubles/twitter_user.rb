def twitter_user
  user = instance_double(Twitter::User)
  allow(user).to receive(:id).
    and_return(random_integer)
  allow(user).to receive(:screen_name).
    and_return(random_string)

  user
end

def twitter_user_collection
  [0..random_integer].to_a.map { |_| twitter_user }
end
