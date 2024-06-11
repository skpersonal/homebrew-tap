cask 'font-moralerspace-neon-nf' do
  version 'v1.0.2'
  sha256 '06dbd8f2bdd5259d07e43e9fd5601f6a62f80a69813cab1801c9e9dc499c71ce'

  url "https://github.com/yuru7/moralerspace/releases/download/#{version}/MoralerspaceNF_#{version}.zip"
  name 'Moralerspace Neon NF'
  desc 'Moralerspace is a programming font that combines Monaspace and IBM Plex Sans JP'
  homepage 'https://github.com/yuru7/moralerspace'

  font "MoralerspaceNF_#{version}/MoralerspaceNeonNF-Bold.ttf"
  font "MoralerspaceNF_#{version}/MoralerspaceNeonNF-BoldItalic.ttf"
  font "MoralerspaceNF_#{version}/MoralerspaceNeonNF-Italic.ttf"
  font "MoralerspaceNF_#{version}/MoralerspaceNeonNF-Regular.ttf"
end
