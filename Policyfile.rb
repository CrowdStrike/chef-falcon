# Policyfile.rb - Describe how you want Chef Infra Client to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile/

# A name that describes what the system you're building with Chef does.
name 'chef-falcon'

# Where to find external cookbooks:
default_source :supermarket

# Specify a custom source for a single cookbook:
cookbook 'chef-falcon', path: '.'
