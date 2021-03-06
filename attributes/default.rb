#
# Cookbook Name:: splunkforwarder
# Attributes:: default
#
# Copyright:: Copyright 2013 Hewlett-Packard, Inc
# License:: Apache License 2.0

# See http://www.splunk.com/download for latest available releases.
# See http://www.splunk.com/page/previous_releases for all available releases.

default['splunkforwarder']['download_url'] = 'http://download.splunk.com/releases'
default['splunkforwarder']['build'] = '185560'
default['splunkforwarder']['version'] = '5.0.6'
default['splunkforwarder']['install_options'] = ''

default['splunkforwarder']['parent_dir'] = '/opt'
default['splunkforwarder']['download_dir'] = '/usr/src'

# default['splunkforwarder']['home'] = '/opt/splunkforwarder'
