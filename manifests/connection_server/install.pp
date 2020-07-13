# @summary
#   This class handles installation/upgrade of primary and replica connection servers.
#
# @api private
#
class vmware_horizon_view::connection_server::install (
  String $installer_drive,
  String $installer_path,
  String $installer_mount_user,
  String $installer_mount_password,
  String $installer_temp_dir,
  String $buildnumber,
  String $version,
  Integer $vdm_server_instance_type,
  String $vdm_initial_admin_sid,
  String $vdm_server_recovery_pwd,
  String $vdm_server_recovery_pwd_reminder,
  String $adam_primary_name,
) {
  # Mount drive  P Drive
  exec { 'Mount Drive':
    command  => "@ECHO OFF
SET pass=${vmware_horizon_view::connection_server::installer_mount_password}
NET USE ${vmware_horizon_view::connection_server::installer_drive} ${vmware_horizon_view::connection_server::installer_path} \
/user:${vmware_horizon_view::connection_server::installer_mount_user} %pass% /persistent:yes",
    path     =>  'C:\Windows\system32',
    unless   => "vol ${vmware_horizon_view::connection_server::installer_drive} >nul 2>nul",
    provider => 'windows',
  }

  # Copy installer to C:\
  -> file { "${vmware_horizon_view::connection_server::installer_temp_dir}/VMware-viewconnectionserver-${vmware_horizon_view::connection_server::version}-${vmware_horizon_view::connection_server::buildnumber}.exe":
    ensure => present,
    source => "${vmware_horizon_view::connection_server::installer_drive}/VMware-viewconnectionserver-${vmware_horizon_view::connection_server::version}-${vmware_horizon_view::connection_server::buildnumber}.exe",
  }
  -> anchor { 'presetup': }

  # Check current version compared to desired version
  if $facts['horizon7_connection_server_version'] < $version {
    # Perform snapshot of vm before update via VMWare API
    exec { 'Take a snapshot':
      command => '',
      require => Anchor['presetup'],
    }

    # Check VDM server type and perform actions accordingly.
    case $vdm_server_instance_type {
      '1': {
        # Install or update primary vdm server
        exec { 'Install primary server':
          require => Anchor['presetup'],
          path    => $vmware_horizon_view::connection_server::installer_temp_dir,
          command => "VMware-viewconnectionserver-${vmware_horizon_view::connection_server::version}-${vmware_horizon_view::connection_server::buildnumber}.exe /s /v\"/qn VDM_SERVER_INSTANCE_TYPE=${vmware_horizon_view::connection_server::vdm_server_instance_type} VDM_INITIAL_ADMIN_SID=${vmware_horizon_view::connection_server::vdm_initial_admin_sid} VDM_SERVER_RECOVERY_PWD=${vmware_horizon_view::connection_server::vdm_server_recovery_pwd} VDM_SERVER_RECOVERY_PWD_REMINDER=\"\"${vmware_horizon_view::connection_server::vdm_server_recovery_pwd_reminder}\"\"\"",
        }

        # Export Installer resource for replicas with tag of ${adam_primary_name}-replica
        @@exec { 'Install replica server':
          require => Anchor['presetup'],
          path    => $vmware_horizon_view::connection_server::installer_temp_dir,
          command => "VMware-viewconnectionserver-${vmware_horizon_view::connection_server::version}-${vmware_horizon_view::connection_server::buildnumber}.exe /s /v\"/qn VDM_SERVER_INSTANCE_TYPE=2 VDM_INITIAL_ADMIN_SID=${vmware_horizon_view::connection_server::vdm_initial_admin_sid} ADAM_PRIMARY_NAME=${vmware_horizon_view::connection_server::adam_primary_name} 
VDM_SERVER_RECOVERY_PWD=${vmware_horizon_view::connection_server::vdm_server_recovery_pwd} VDM_SERVER_RECOVERY_PWD_REMINDER=\"\"${vmware_horizon_view::connection_server::vdm_server_recovery_pwd_reminder}\"\"\"",
          tag     => "${adam_primary_name}-replica",
        }
      }
      '2': {
        # Collect exported resources from master to indicate that it is time to install or update replicas.
        # Import resources with tag of  ${adam_primary_name}-replica
        Exec <| tag == "${adam_primary_name}-replica" |>

      }
      default: {
        notify { "Unknown vdm_server_instance_type, got ${vdm_server_instance_type} but expected 1 or 2.": }
      }
    }
  }
}
