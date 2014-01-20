if defined?(ChefSpec)
  def add_bash_profile(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:bash_profile, :add, resource_name)
  end
end