#
# Cookbook Name:: git
# Recipe:: default
#
# Copyright 2010, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
root = File.expand_path(File.join(File.dirname(__FILE__), ".."))

require root + '/resources/homebrew'
require root + '/providers/homebrew'
require 'etc'

directory "#{ENV['HOME']}/Developer" do
  action :create
end

execute "setup PATH in ~/.profile" do
  command "echo 'PATH=#{ENV['HOME']}/Developer/bin:$PATH' >> ~/.profile"
  not_if  "grep -q 'Developer/bin:$PATH' ~/.profile"
end

execute "reload ~/.profile" do
  command "source ~/.profile"
end

execute "download homebrew installer" do
  command "/usr/bin/curl -sfL http://github.com/mxcl/homebrew/tarball/master | /usr/bin/tar xz -m --strip 1"
  cwd     "#{ENV['HOME']}/Developer"
  not_if  "test -e ~/Developer/bin/brew"
end

script "updating homebrew from github" do
  interpreter "bash"
  code <<-EOS
    ~/Developer/bin/brew update
  EOS
end



# Installing git 
homebrew "git"

