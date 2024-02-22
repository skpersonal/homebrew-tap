cask "font-moralerspace-neon-nf" do
    version "0.0.8"
    sha256 :no_check
  
    url "https://github.com/yuru7/moralerspace/releases/download/v#{version}/MoralerspaceNF_v#{version}.zip"
    name "Moralerspace Neon NF"
    homepage "https://github.com/yuru7/moralerspace"
  
    font "MoralerspaceNeonNF-Bold.ttf"
    font "MoralerspaceNeonNF-BoldItalic.ttf"
    font "MoralerspaceNeonNF-Italic.ttf"
    font "MoralerspaceNeonNF-Regular.ttf"
  end