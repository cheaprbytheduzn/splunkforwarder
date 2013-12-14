#
# Cookbook Name:: splunkforwarder
# Recipe:: package
#
# Author:: Ken Miles <mailto:ken.miles@hp.com>
# Source:: https://github.com/cheaprbytheduzn/splunkforwarder
# Copyright:: Copyright 2013 Hewlett-Packard, Inc
# License:: Apache License 2.0

download_dir = '/usr/src'

# E.g:  /usr/src/splunkforwarder-5.0.6-185560-linux-2.6-x86_64.rpm
package_prefix = [
  'splunkforwarder',
  node['splunkforwarder']['version'],
  node['splunkforwarder']['build']
].join('-')

Chef::Log.info("platform_family = #{node['platform_family']}; \
  kernel.machine = #{node['kernel']['machine']}")

if platform_family?("rhel", "suse", "fedora")
  package_suffix = node['kernel']['machine'] == 'x86_64' ? '-linux-2.6-x86_64.rpm' : '.i386.rpm'
elsif platform_family?("debian")
  package_suffix = node['kernel']['machine'] == 'x86_64' ? '-linux-2.6-amd64.deb' : '-linux-2.6-intel.deb'
else
  raise "Unsupported platform_family: #{node['platform_family']}"
end

package_name = [package_prefix, package_suffix].join
package_download_path = File.join(download_dir, package_name)
Chef::Log.info("package_name = #{package_name}")

# e.g http://downloads.splunk.com/5.0/u/l/s-1.2.3-12345.tar.gz
package_url = [
  node['splunkforwarder']['download_url'],
  node['splunkforwarder']['version'],
  'universalforwarder',
  'linux',
  package_name
].join('/')

directory download_dir

remote_file 'splunkforwarder: Download Package' do
  action :nothing
  backup false
  checksum node['splunkforwarder']['checksum']
  path package_download_path
  source package_url
end

http_request 'splunkforwarder: Check Package URL' do
  action :head
  if ::File.exists?(package_download_path)
    headers 'If-Modified-Since' => ::File.mtime(package_download_path).httpdate
  end
  message ''
  notifies(:create,
           resources(:remote_file => 'splunkforwarder: Download Package'),
           :immediately)
  url package_url
end

# package package_name do
#   options node['splunkforwarder']['install_options']
#   source package_download_path
# end
# As of Chef 11.8, does not install successfully from file without specifiying 
# the provider directly. So, ...

package package_name do
  options node['splunkforwarder']['install_options']
  case node['platform_family']
  when "rhel"
    provider Chef::Provider::Package::Rpm
  when "debian"
    provider Chef::Provider::Package::Dpkg
  else 
    raise "Unsupported platform_family: #{node['platform_family']}"
  end
  source package_download_path
end
