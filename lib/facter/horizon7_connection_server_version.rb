#
# Written to identify version of VMWare Horizon 7 connection server
#
# When Horizon 8 comes out, copy this file edit horizon7 and replace with horizon8
# Then you will alter the IdentifyingNumber in the registry path on line 12 below.
#
Facter.add('horizon7_connection_server_version') do
  confine kernel: :windows
  require 'win32/registry'

  setcode do
    Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{BA8F6334-CB3D-42C2-A6FF-C4A90A3314B7}') do |reg|
      reg.each_value do |_name, _type, displayversion|
        displayversion
      end
    end
  end
end
