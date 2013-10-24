require 'etc'

use_inline_resources

action :add do
  init

  file ::File.join(profile_d, new_resource.filename) do
    content new_resource.content
    owner new_resource.user
    group Etc.getpwnam(new_resource.user).gid
    mode 0644
  end
end

def init
  directory profile_d do
    owner new_resource.user
    group Etc.getpwnam(new_resource.user).gid
    mode 0755
  end

  ruby_block "move old .bash_profile into #{profile_d}" do
    block do
      require 'fileutils'
      FileUtils.mv bash_profile, ::File.join(profile_d, "init")
    end
    not_if {::File.exists?(::File.join(profile_d, "init"))}
  end

  cookbook_file bash_profile do
    cookbook "bash"
    source "bash_profile"
    owner new_resource.user
    group Etc.getpwnam(new_resource.user).gid 	
    mode 0644 
  end
end

def initial_config?
  ::File.directory?(profile_d)
end

def profile_d
  ::File.join(::Dir.home(new_resource.user), ".bash_profile.d")
end

def bash_profile
  ::File.join(::Dir.home(new_resource.user), ".bash_profile")
end
