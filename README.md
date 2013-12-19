splunkforwarder
===============

Install and configure the Splunk Forwarder with Chef onto a Linux Client.

[![Build Status](https://secure.travis-ci.org/cheaprbytheduzn/splunkforwarder.png?branch=master)](http://travis-ci.org/cheaprbytheduzn/splunkforwarder)

Requirements
------------
Chef 0.10.10+

Platform
--------
- Debian, Ubuntu
- CentOS, Red Hat, Fedora

Tested on:

- Chef 11.0+
- Ubuntu 12.04
- CentOS 5.8, 6.4

Attributes
----------

See attributes/default.rb for details and defaults.

Set `build` and `version` to specify a specific download.

See http://www.splunk.com/download for latest available releases.

See http://www.splunk.com/page/previous_releases for all available releases.

Attribute Examples:

The Splunkforwarder package is relocatable.  Use `install_options` to install to an alternate location.  E.g. with Yum:

```javascript
node['splunkforwarder']['install_options'] = '--allfiles --relocate /opt=/opt/apps/ms'
```
Author
-----------------
- Author:: Ken Miles (<ken.miles@hp.com>)

Credits
-----------------
The Splunkforwarder Cookbook is based on https://github.com/ampledata/cookbook-splunkforwarder
by Greg Albrecht which in turn is based upon https://github.com/lexerdev/splunkstorm by 
Aaron Wallis.

```text
Copyright 2012 Hewlett-Packard, Inc.
Copyright 2012 Splunk, Inc.
Copyright 2012-2013, Lexer Pty Ltd

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

