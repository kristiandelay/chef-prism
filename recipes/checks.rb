#
# Cookbook Name:: prism
# Recipe:: checks
#
# Copyright (C) 2013 Jean-Francois Theroux
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe 'prism::default'
include_recipe 'prism::plugins'

plugins = '/etc/sensu/plugins'

# CPU
sensu_check 'check_cpu' do
  command "#{plugins}/system/check-cpu.rb"
  handlers ['default']
  subscribers ['linux']
end

# Load
sensu_check 'check_load' do
  command "#{plugins}/system/check-load.rb -w 5,10,15 -c 10,15,20 -p"
  handlers ['default']
  subscribers ['linux']
end

# RAM
sensu_check 'check_ram' do
  command "#{plugins}/system/check-ram.rb -w 10 -c 5"
  handlers ['default']
  subscribers ['linux']
end

# Disks
sensu_check 'check_disks' do
  command "#{plugins}/system/check-disk.rb -w 85 -c 95"
  handlers ['default']
  subscribers ['linux']
end

# FSTAB
sensu_check 'check_fstab' do
  command "#{plugins}/system/check-fstab-mounts.rb -t ext4"
  handlers ['default']
  subscribers ['linux']
end
