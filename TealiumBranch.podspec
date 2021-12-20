Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.name         = "TealiumBranch"
  spec.version      = "1.0.0"
  spec.summary      = "Tealium Swift and Branch integration"
  spec.description  = <<-DESC
  Tealium's integration with Branch for iOS.
  DESC
  spec.homepage = "https://bitbucket.org/tealium_mobile/tealium-ios-branch-remote-command.git"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.license      = { :type => "Commercial", :file => "LICENSE.txt" }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.authors             = { "Tealium Inc." => "tealium@tealium.com", "trister1997" => "tyler.rister@tealium.com" }
  spec.social_media_url    = "https://twitter.com/tealium"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.platform     = :ios, "10.0"
  spec.swift_version = "4.2"
  spec.ios.deployment_target = "10.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source       = { :git => "https://bitbucket.org/tealium_mobile/tealium-ios-branch-remote-command.git", :tag => "#{spec.version}" }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source_files  = "Sources/*.{swift}"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.ios.dependency 'tealium-swift/Core', ' ~> 2.4.6'
  spec.ios.dependency 'tealium-swift/RemoteCommands', ' ~> 2.4.6'
  spec.ios.dependency 'tealium-swift/TagManagement', ' ~> 2.4.6'
  spec.ios.dependency 'Branch', ' ~> 1.40.1'

end
