# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include vmware_horizon_view::server
class vmware_horizon_view::connection_server (
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
  contain vmware_horizon_view::connection_server::install
  contain vmware_horizon_view::connection_server::config
  contain vmware_horizon_view::connection_server::service

  Class['vmware_horizon_view::connection_server::install']
  -> Class['vmware_horizon_view::connection_server::config']
  ~> Class['vmware_horizon_view::connection_server::service']
}

