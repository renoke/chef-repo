#
# Cookbook Name:: rvm
# Recipe:: default
#

execute "download homebrew installer" do
  command "mkdir -p .rvm/src/ && cd .rvm/src && rm -rf ./rvm/ && git clone --depth 1 git://github.com/wayneeseguin/rvm.git && cd rvm && ./install"
  cwd     "#{ENV['HOME']}/Developer"
  not_if  "ls ~/Developer/bin/.rvm"
end

execute "update rvm" do
  command "#{ENV['HOME']}/Developer/.rvm/bin/rvm update"
end

execute "reload rvm" do
  command "#{ENV['HOME']}/Developer/.rvm/bin/rvm reload"
end

node[:rubies].each do |ruby|
  Log.info("Installing #{ruby}")
  script "installing ruby" do    
    interpreter "bash"
    code <<-EOS
      `rvm list | grep -q '#{ruby}'`
      if [ $? -ne 0 ]; then
        rvm install #{ruby}
      fi
    EOS
  end
end

execute "set ruby default" do
  command "rvm use #{node[:ruby_default_version]} --default"
end

execute "remove textmate builder" do
  path = '/Applications/TextMate.app/Contents/SharedSupport/Support/lib/ '
  command "cd #{path} ; mv Builder.rb Builder.rb.backup"
  only_if do File.exist?("#{path}/Builder.rb") end
end

template "#{ENV['HOME']}/Developer/.rvm/gemsets/default.gems" do
  source "default.gems.erb"
end

execute "install default rubygems" do
  command "rvm gemset load ~/Developer/.rvm/gemsets/default.gems"
end

template "#{ENV['HOME']}/.irbrc" do
  source "dot.irbrc.erb"
end

template "#{ENV['HOME']}/.gemrc" do
  source "dot.gemrc.erb"
end

template "#{ENV['HOME']}/.rdebugrc" do
    source "dot.rdebugrc.erb"
end




