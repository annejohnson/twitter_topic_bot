def twitter_user
  user = instance_double(Twitter::User)
  allow(user).to receive(:id).
    and_return(random_integer)

  user
end
