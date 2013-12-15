#
# Cookbook Name:: splunkforwarder
# Recipe:: service
#
# Copyright:: Copyright 2013 Hewlett-Packard, Inc
# License:: Apache License 2.0

execute '/opt/splunkforwarder/bin/splunk enable boot-start --accept-license' +
    ' --answer-yes' do
  not_if { File.symlink?('/etc/rc4.d/S20splunk') }
end

service 'splunk' do
  action [:start]
  supports :status => true, :start => true, :stop => true, :restart => true
end
