#
# Cookbook Name:: splunkforwarder
# Copyright:: Copyright 2013 Hewlett-Packard, Inc
# License:: Apache License 2.0

name    'splunkforwarder'
version '0.1.1'

maintainer 'Ken Miles'
maintainer_email 'ken.miles@hp.com'
license 'Apache License 2.0'

%w{redhat rhel centos fedora debian suse ubuntu}.each do |os|
  supports os
end

long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
