cask "font-moralerspace-neon-nf" do
    version "0.0.8"
    sha256 :no_check
  
    url "https://github.com/yuru7/moralerspace/releases/download/v#{version}/MoralerspaceNF_v#{version}.zip"
    name "Moralerspace Neon NF"
    desc "Moralerspace is a programming font that combines Monaspace and IBM Plex Sans JP"
    homepage "https://github.com/yuru7/moralerspace"
  
    font "MoralerspaceNF_v#{version}/MoralerspaceNeonNF-Bold.ttf"
    font "MoralerspaceNF_v#{version}/MoralerspaceNeonNF-BoldItalic.ttf"
    font "MoralerspaceNF_v#{version}/MoralerspaceNeonNF-Italic.ttf"
    font "MoralerspaceNF_v#{version}/MoralerspaceNeonNF-Regular.ttf"
end