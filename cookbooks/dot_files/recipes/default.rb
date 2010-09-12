#
# Cookbook Name:: dotfiles
# Recipe:: default
#

execute "clone dotfiles" do
  command "git clone git://github.com/renoke/dotfiles.git"
  cwd     "#{ENV['HOME']}/Developer"
  not_if  do File.exist?("#{ENV['HOME']}/Developer/dotfiles") end
end

execute "symlink .zshenv" do
  command "ln -s #{ENV['HOME']}/Developer/dotfiles/zsh/env #{ENV['HOME']}/.zshenv"
  not_if do File.exist?("#{ENV['HOME']}/.zshenv") end
end

execute "symlink .zshrc" do
  command "ln -s #{ENV['HOME']}/Developer/dotfiles/zshrc #{ENV['HOME']}/.zshrc"
  not_if do File.exist?("#{ENV['HOME']}/.zshrc") end
end

execute "install vcprompt" do
  command "curl -s http://github.com/xvzf/vcprompt/raw/master/bin/vcprompt > ~/Developer/bin/vcprompt"
end

file "#{ENV['HOME']}/Developer/bin/vcprompt" do
  mode "0755"
end

execute "reload .zshrc" do
  command "source ~/.zshrc"
end


