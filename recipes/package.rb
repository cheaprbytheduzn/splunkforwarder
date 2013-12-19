#
# Cookbook Name:: splunkforwarder
# Recipe:: package
#
# Copyright:: Copyright 2013 Hewlett-Packard, Inc
# License:: Apache License 2.0

dirlist = []
download_dir = node['splunkforwarder']['download_dir']
dirlist << download_dir
dirlist << node['splunkforwarder']['parent_dir']

dirlist.each do |dir|
  directory dir do
    mode '0755'
    owner 'root'
    group 'root'
    recursive true
  end
end

# E.g:  /usr/src/splunkforwarder-5.0.6-185560-linux-2.6-x86_64.rpm
package_prefix = [
  'splunkforwarder',
  node['splunkforwarder']['version'],
  node['splunkforwarder']['build']
].join('-')

if platform_family?('rhel', 'suse', 'fedora')
  package_suffix = node['kernel']['machine'] == 'x86_64' ? '-linux-2.6-x86_64.rpm' : '.i386.rpm'
elsif platform_family?('debian')
  package_suffix = node['kernel']['machine'] == 'x86_64' ? '-linux-2.6-amd64.deb' : '-linux-2.6-intel.deb'
else
  Chef::Application.fatal!("Unsupported platform_family: #{node['platform_family']}")
end

package_name = [package_prefix, package_suffix].join
pkg_file = File.join(download_dir, package_name)

# e.g http://downloads.splunk.com/releases/5.0.6/universalforwarder/linux/splunkforwarder-5.0.6-1855560.i386.rpm
package_url = [
  node['splunkforwarder']['download_url'],
  node['splunkforwarder']['version'],
  'universalforwarder',
  'linux',
  package_name
].join('/')

def use_remote_file(pkg_file, package_url)
  remote_file 'download-package' do
    backup false
    checksum node['splunkforwarder']['checksum']
    path pkg_file
    source package_url
    if ::File.exists?(pkg_file)
      headers('last_modified' => ::File.mtime(pkg_file).httpdate)
    end
  end
end

def use_http_request_trick(pkg_file, package_url)
  # Prior to 11.6, this was a tactic that could be employed to avoid downloading
  # unless the source had been modified.  As of 11.6 this is no longer necessary
  # per: https://tickets.opscode.com/browse/CHEF-2506.
  # In addition, as of 11.8 we must not try this at all in light of:
  # https://tickets.opscode.com/browse/CHEF-4762

  remote_file 'download-package' do
    action :nothing
    backup false
    checksum node['splunkforwarder']['checksum']
    path pkg_file
    source package_url
  end

  http_request 'splunkforwarder: Check Package URL' do
    action :head
    if ::File.exists?(pkg_file)
      headers 'If-Modified-Since' => ::File.mtime(pkg_file).httpdate
    end
    message ''
    notifies(:create, 'remote_file[download-package]', :immediately)
    url package_url
  end
end

Chef::Log.info "Detected Chef version: #{node['chef_packages']['chef']['version']}"
if node['chef_packages']['chef']['version'].to_f < 11.6
  use_http_request_trick(pkg_file, package_url)
else
  use_remote_file(pkg_file, package_url)
end

# package package_name do
#   options node['splunkforwarder']['install_options']
#   source pkg_file
# end
# As of Chef 11.8, does not install successfully from file without specifiying
# the provider directly. So, ...

package package_name do
  options node['splunkforwarder']['install_options']
  case node['platform_family']
  when 'rhel'
    provider Chef::Provider::Package::Rpm
  when 'debian'
    provider Chef::Provider::Package::Dpkg
  else
    Chef::Application.fatal!("Unsupported platform_family: #{node['platform_family']}")
  end
  source pkg_file
end
