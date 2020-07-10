#
# Written to identify version of VMware vCenter Converter Standalone
#
#
Facter.add('vmware_vcenter_converter_standalone_version') do
  confine kernel: :windows
  require 'win32/registry'

  setcode do
    Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{DA09FD63-5AE7-4bf6-8B86-0FCA4DEA8F8F}') do |reg|
      reg.each_value do |_name, _type, displayversion|
        displayversion
      end
    end
  end
end
