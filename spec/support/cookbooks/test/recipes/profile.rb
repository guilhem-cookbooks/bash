bash_profile 'test1' do
  user 'test_user'
  content 'test1'
end

bash_profile 'test2' do
  action :remove
  user 'test_user'
end