Pod::Spec.new do |s|
  s.name             = 'WorkoutApp'
  s.version          = '1.0.0'
  s.summary          = 'Workout personal trainer.'
  s.homepage         = 'https://github.com/leowirasanto2/pondasi'
  s.license          = { :type => 'Proprietary' }
  s.author           = { 'Leo Wirasanto' => 'leo@pondasi.local' }

  s.source           = { :git => 'git@github.com:leowirasanto2/pondasi.git', :tag => "workout-v#{s.version}" }

  # Crucial: Point to the internal folder for this specific pod
  s.source_files     = 'Sources/**/*'
  s.dependency 'PondasiContracts'
  s.ios.deployment_target = '17.0'
end
