# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include vmware_horizon_view::server
class vmware_horizon_view::server (
   String $installer_drive,
   String $installer_path,
   String $buildnumber,
   String $version,
   Integer $vdm_server_instance_type,
   String $vdm_initial_admin_sid,
   String $vdm_server_recovery_pwd,
   String $vdm_server_recovery_pwd_reminder,
   String $adam_primary_name,
) {
  # Check VDM server type and perform actions accordingly.
  case $vdm_server_instance_type {
    '1': {
       # Install or update primary vdm server
    }
    '2': {
      # Collect exported resources from master to indicate that it is time to install or update replicas.

    }
    default: {
      notify { "Unknown vdm_server_instance_type, got ${vdm_server_instance_type} but expected 1 or 2.": }
    }
  }
}
