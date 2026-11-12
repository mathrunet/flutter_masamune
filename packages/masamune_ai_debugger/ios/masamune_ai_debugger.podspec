#
# Native support for masamune_ai_debugger.
#
# The microphone capture used by the real-time voice input is compiled only
# when the `MASAMUNE_AI_DEBUGGER_VOICE` build setting is `YES`. Flutter passes
# it to every target when the build runs with
# `FLUTTER_XCODE_MASAMUNE_AI_DEBUGGER_VOICE=YES`. Without it the plugin is a
# stub that links no audio APIs.
#
Pod::Spec.new do |s|
  s.name             = 'masamune_ai_debugger'
  s.version          = '0.0.1'
  s.summary          = 'AI debug overlay and error reporting adapter for Masamune apps.'
  s.description      = <<-DESC
AI debug overlay and error reporting adapter for Masamune apps.
                       DESC
  s.homepage         = 'https://mathru.net'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'mathru' => 'info@mathru.net' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'MASAMUNE_AI_DEBUGGER_VOICE_SWIFT_FLAG_YES' => '-DMASAMUNE_AI_DEBUGGER_VOICE',
    'OTHER_SWIFT_FLAGS' => '$(inherited) $(MASAMUNE_AI_DEBUGGER_VOICE_SWIFT_FLAG_$(MASAMUNE_AI_DEBUGGER_VOICE))',
  }
  s.swift_version = '5.0'
end
