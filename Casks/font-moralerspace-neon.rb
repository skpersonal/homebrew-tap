cask 'font-moralerspace-neon' do
  version 'v1.0.0'
  sha256 '8a6b4a011be5757b0e471f21af021e142259d9f23f13e34e9e3ecf179d37624f'

  url "https://github.com/yuru7/moralerspace/releases/download/#{version}/Moralerspace_#{version}.zip"
  name 'Moralerspace Neon'
  desc 'Moralerspace is a programming font that combines Monaspace and IBM Plex Sans JP'
  homepage 'https://github.com/yuru7/moralerspace'

  font "Moralerspace_#{version}/MoralerspaceNeon-Bold.ttf"
  font "Moralerspace_#{version}/MoralerspaceNeon-BoldItalic.ttf"
  font "Moralerspace_#{version}/MoralerspaceNeon-Italic.ttf"
  font "Moralerspace_#{version}/MoralerspaceNeon-Regular.ttf"
end
