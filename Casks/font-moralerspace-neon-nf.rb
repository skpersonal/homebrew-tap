cask "font-moralerspace-neon-nf" do
    version "v1.0.0"
    sha256 "728196c407a921e5e2905aedebe18ffea5370598f346b0a25a13c0bf5e02c974"
  
    url "https://github.com/yuru7/moralerspace/releases/download/#{version}/MoralerspaceNF_#{version}.zip"
    name "Moralerspace Neon NF"
    desc "Moralerspace is a programming font that combines Monaspace and IBM Plex Sans JP"
    homepage "https://github.com/yuru7/moralerspace"
  
    font "MoralerspaceNF_#{version}/MoralerspaceNeonNF-Bold.ttf"
    font "MoralerspaceNF_#{version}/MoralerspaceNeonNF-BoldItalic.ttf"
    font "MoralerspaceNF_#{version}/MoralerspaceNeonNF-Italic.ttf"
    font "MoralerspaceNF_#{version}/MoralerspaceNeonNF-Regular.ttf"
end