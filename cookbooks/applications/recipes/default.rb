# Load the GitChanged extension
#
[Chef::Recipe, Chef::Resource].each { |l| l.send :include, GitChanged }

# Create user directory
#
directory node.applications[:dir] do
  owner node.applications[:user] and group node.applications[:user] and mode 0775
  recursive true
end

# Create user and group
#
user node.applications[:user] do
  comment  "Applications User"
  shell    "/bin/bash"
  home     node.applications[:dir]
  supports :manage_home => true
  action   :create
end

group node.applications[:user] do
  members [ node.applications[:user]]
  action :create
end

directory node.applications[:dir] do
  owner node.applications[:user] and group node.applications[:user] and mode 0775
  recursive true
end

include_recipe "elasticsearch::nginx"

directory "#{node.applications[:dir]}/.ssh" do
  owner node.applications[:user] and group node.applications[:user] and mode 0700
  recursive true
end
