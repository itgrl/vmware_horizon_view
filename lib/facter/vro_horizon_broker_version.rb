#
# Written to identify version of VMware vRealize Operations for Horizon Broker Agent
#
#
Facter.add('vro_horizon_broker_version') do
  confine kernel: :windows
  require 'win32/registry'

  setcode do
    Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{FBB97A8E-AFA5-4658-85DD-CF5995572639}') do |reg|
      reg.each_value do |_name, _type, displayversion|
        displayversion
      end
    end
  end
end
