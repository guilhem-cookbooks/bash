actions :add

default_action :add

attribute :filename, :kind_of => String, :name_attribute => true
attribute :user, :kind_of => String, :required => true
attribute :content, :kind_of => String, :required => true
