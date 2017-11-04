#
# Cookbook Name:: biodiv-nameparser
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# install ruby
if node['platform'] == 'ubuntu' && node['platform_version'].to_f <= 14.04
  apt_package "ruby2.0" do
    action :install
  end
else
  apt_repository 'brightbox-ruby-ng' do
    uri        'http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu'
    distribution node['lsb']['codename']
    components ['main', 'stable']
  end

  e = apt_update 'update' do
    action :nothing
  end
  e.run_action(:update)

  apt_package "ruby" do
    action :install
  end
end


# create user
#  create the user that runs nameparser
user node.nameparser.user do
  comment "nameparser user"
  system true
  shell "/bin/false"
end

#  create the group that runs nameparser
group node.nameparser.group do
  members node.nameparser.user
  append true
end

# create name parser home
directory node['nameparser']['home'] do
recursive true
owner node.nameparser.user
group node.nameparser.group
action :create
end

# install biodiversity gem
bash "install biodiversity gem" do
  code "gem install biodiversity"
  not_if "test -f #{node.nameparser.binary}"
end

# define the nameparser service
service "nameparser" do
   if platform?("ubuntu")
        provider Chef::Provider::Service::Upstart
   end

   action :nothing
   supports :status => true, :start => true, :stop => true, :restart => true
end

# upstart script
template "/etc/init/nameparser.conf" do
  source "nameparser-upstart.conf.erb"
        only_if { platform?("ubuntu") }
  notifies :restart, resources(:service => "nameparser"), :immediately
end

systemd_unit 'nameparser.service' do
  content <<-EOU.gsub(/^\s+/, '')
  [Unit]
  Description=biodiversity nameparser
  Requires=network-online.target
  After=network-online.target


  [Service]
  PIDFile=/var/run/nameparser.pid
  WorkingDirectory=#{node.nameparser.home}
  User=#{node.nameparser.user}
  Group=#{node.nameparser.group}
  Environment=GOMAXPROCS=2
  Restart=on-failure
  ExecStart=#{node.nameparser.binary} --background --start -- ""
  ExecReload=/bin/kill -HUP $MAINPID
  KillSignal=SIGINT


  [Install]
  WantedBy=multi-user.target
  EOU

  action [:create, :enable, :start]
end
