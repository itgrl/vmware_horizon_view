#
# Written to identify version of VMware Tools
#
#
Facter.add('vmware_tools_version') do
  confine kernel: :windows
  require 'win32/registry'

  setcode do
    Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{25932044-BBC8-444F-ACF4-7E508054FA12}') do |reg|
      reg.each_value do |_name, _type, displayversion|
        displayversion
      end
    end
  end
end
