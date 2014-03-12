#
# Cookbook Name:: rs-storage
# Recipe:: schedule
#
# Copyright (C) 2013 RightScale, Inc.
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
#

schedule_enable = node['rs-storage']['backup']['schedule']['enable'] == true || node['rs-storage']['backup']['schedule']['enable'] == 'true'
schedule_hour = node['rs-storage']['backup']['schedule']['hour']
schedule_minute = node['rs-storage']['backup']['schedule']['minute']
lineage = node['rs-storage']['backup']['lineage']

unless schedule_hour && schedule_minute
  raise 'rs-storage/backup/schedule/hour and rs-storage/backup/schedule/minute inputs should be set'
end

cron "backup_schedule_#{lineage}" do
  minute schedule_minute
  hour schedule_hour
  command "rs_run_recipe --policy 'rs-storage::backup' --name 'rs-storage::backup'"
  action schedule_enable ? :create : :delete
end
