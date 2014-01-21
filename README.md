# bash cookbook

[![Build Status](https://travis-ci.org/optiflows-cookbooks/bash.png)](https://travis-ci.org/optiflows-cookbooks/bash)

This cookbook provides a simple `bash_profile` LWRP.

It create multiple files in bash\_profile.d folder and merge them into bash\_profile file without loosing any local existing version.

Obviously, it works only on Linux platform.

## Usage
Just add `bash` to your cookbook dependency list.

## Requirement
N/C

## Resource / Provider
* `bash_profile` : does the init/setup/parse/merge process. This LWRP will create bash\_profile.d folder if not present.

If an existing bash_profile file exists in user home folder, it will be saved in a permanent init file at the very first run and then will be merged each time LWRP is called.

### Action
* `add:` (default) - add a specified file to bash\_profile.d folder and merge all files from this folder to given user bash\_profile file.
* `remove:` - remove a specified file from bash\_profile.d folder.

## Attributes

* `filename` - name of the file

* `user` - user to interact with. Group and home folder will be automaticly resolved from system informations.

* `content` - String to be set on the new profile file. It easily works with simple string, multiline string, or strings loaded from a file.

#### Syntax

    bash_profile 'profile.addin' do
      user 'jdoe'
      content "PATH=/home/jdoe/my_bin:$PATH"
    end
    
## Testing

Includes basic [chefspec](sethvargo/chefspec) support and matchers.

1. `bundle install`
2. `rspec`

## Author

Author:: Guilhem Lettron (<guilhem.lettron@optiflows.com>)
