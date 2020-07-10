#
# author: Andreas Wilke
#
# Written to send the current Horizon View PCOIP minimum image quality as fact.
#
Facter.add('horizon_view_pcoip_minimum_image_quality') do
  confine kernel: :windows

  horizon_view_pcoip_minimum_image_quality = 'unknown'
  begin
    if RUBY_PLATFORM.downcase.include?('mswin') || RUBY_PLATFORM.downcase.include?('mingw32')
      require 'win32/registry'

      Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\Policies\Teradici\PCoIP\pcoip_admin') do |reg|
        reg.each_value do |name, _type, data|
          if name == 'pcoip.minimum_image_quality'
            horizon_view_pcoip_minimum_image_quality = data
          end
        end
      end
    end
  end

  setcode do
    horizon_view_pcoip_minimum_image_quality
  end
end
