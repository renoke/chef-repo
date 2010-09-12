#
# Cookbook Name:: zena
# Recipe:: default
#

# create gemsets for each version of zena
node[:zena_gemsets].each do |version|
  script "create gemset for #{version} " do    
    interpreter "bash"
    code <<-EOS
      `rvm list | grep -q '#{version}'`
      if [ $? -ne 0 ]; then
        rvm gemset create #{version}
      fi
    EOS
  end
end

template "#{ENV['HOME']}/Developer/.rvm/gemsets/default.gems" do
  source "zena100.gems.erb"
end

execute "use default zena gemset" do
  command "rvm use #{node[:default_ruby_version]}@#{node[:default_zena_gemset]}"
end

execute "load default gemset" do
  command "rvm gemset load ~/Developer/.rvm/gemsets/default.gems"
end

execute "load zena100 gemset" do
  command "rvm gemset load ~/Developer/.rvm/gemsets/zena100.gems"
end





