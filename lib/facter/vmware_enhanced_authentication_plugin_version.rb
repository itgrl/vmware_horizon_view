#
# Written to identify version of VMware Enhanced Authentication Plug-in 6.7.0
#
#
Facter.add('vmware_enhanced_authentication_plugin_version') do
  confine kernel: :windows
  require 'win32/registry'

  setcode do
    Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{AA33F9ED-8FD1-480D-8786-FB2E2F9BE1EE}') do |reg|
      reg.each_value do |_name, _type, displayversion|
        displayversion
      end
    end
  end
end
