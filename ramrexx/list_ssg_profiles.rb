# list_ssg_profiles
def log(level, msg, update_message = false)
  $evm.log(level, "#{msg}")
  @task.message = msg if @task && (update_message || level == 'error')
end

# dialog_hash = {}
ssgs = ['ssg-rhel7-role-common', 'ssg-rhel7-role-cjis-rhel7-server',
  'ssg-rhel7-role-C2S','ssg-rhel7-role-docker-host',
  'ssg-rhel7-role-nist-800-171-cui','ssg-rhel7-role-ospp-rhel7',
  'ssg-rhel7-role-pci-dss','ssg-rhel7-role-rht-ccp',
  'ssg-rhel7-role-standard','ssg-rhel7-role-stig-rhel7-disa',
  'ssg-rhel7-role-stig-rhevh-upstream']

# ssgs.each do |profile|
#   dialog_hash["#{profile}"] = profile
# end
#
# if dialog_hash.blank?
#   dialog_hash[''] = "< no ssgs found >"
# else
#   $evm.object['default_value'] = dialog_hash.first[0]
# end

$evm.object["values"]     = ssgs
log(:info, "$evm.object['values']: #{$evm.object['values'].inspect}")
