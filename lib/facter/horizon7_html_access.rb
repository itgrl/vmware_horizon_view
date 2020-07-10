#
# Written to identify version of VMware Horizon 7 HTML Access
#
Facter.add('horizon7_html_access') do
  confine kernel: :windows
  require 'win32/registry'

  setcode do
    Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{2C0B6B86-DA73-4A92-8CB8-0EE7E98F6EB6}') do |reg|
      reg.each_value do |_name, _type, displayversion|
        displayversion
      end
    end
  end
end
