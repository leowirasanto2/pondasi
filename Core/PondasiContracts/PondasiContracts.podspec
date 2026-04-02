Pod::Spec.new do |s|
  s.name             = 'PondasiContracts'
  s.version          = '1.0.0'
  s.summary          = 'Core protocols for the Pondasi local-first ecosystem.'
  s.homepage         = 'https://github.com/leowirasanto2/pondasi'
  s.license          = { :type => 'Proprietary' }
  s.author           = { 'Leo Wirasanto' => 'leo@pondasi.local' }

  # Updated to use your SSH URL
  s.source           = { :git => 'git@github.com:leowirasanto2/pondasi.git', :tag => "core-v#{s.version}" }

  s.source_files     = 'PondasiContracts/**/*.swift'
  s.ios.deployment_target = '17.0'
  s.swift_version    = '6.0'
  s.frameworks       = 'Foundation', 'SwiftUI'
end