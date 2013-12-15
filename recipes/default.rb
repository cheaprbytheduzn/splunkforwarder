#
# Cookbook Name:: splunkforwarder
# recipe:: default
# Copyright:: Copyright 2013 Hewlett-Packard, Inc
# License:: Apache License 2.0

include_recipe 'splunkforwarder::package'
include_recipe 'splunkforwarder::service'
