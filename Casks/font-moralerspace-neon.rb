cask 'font-moralerspace-neon' do
  version 'v1.0.1'
  sha256 '77568a436c0664ba37c5f94dcb379dce0693da2ca65b1ba7d12d049f3f1c9c80'

  url "https://github.com/yuru7/moralerspace/releases/download/#{version}/Moralerspace_#{version}.zip"
  name 'Moralerspace Neon'
  desc 'Moralerspace is a programming font that combines Monaspace and IBM Plex Sans JP'
  homepage 'https://github.com/yuru7/moralerspace'

  font "Moralerspace_#{version}/MoralerspaceNeon-Bold.ttf"
  font "Moralerspace_#{version}/MoralerspaceNeon-BoldItalic.ttf"
  font "Moralerspace_#{version}/MoralerspaceNeon-Italic.ttf"
  font "Moralerspace_#{version}/MoralerspaceNeon-Regular.ttf"
end
