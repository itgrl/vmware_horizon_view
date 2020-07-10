#
# Written to identify version of VMWare Remote Console Plug-in 5.1
#
#
Facter.add('vmware_remote_console_plugin_version') do
  confine kernel: :windows
  require 'win32/registry'

  setcode do
    Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{10BA75D4-F1F6-41DC-A052-3AFA3209AA80}') do |reg|
      reg.each_value do |_name, _type, displayversion|
        displayversion
      end
    end
  end
end
