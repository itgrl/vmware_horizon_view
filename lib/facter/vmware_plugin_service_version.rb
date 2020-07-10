#
# Written to identify version of VMware Plug-in Service
#
#
Facter.add('vmware_plugin_service_version') do
  confine kernel: :windows
  require 'win32/registry'

  setcode do
    Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{04FA3839-584D-4A66-9DA8-C502FB4315DD}') do |reg|
      reg.each_value do |_name, _type, displayversion|
        displayversion
      end
    end
  end
end
