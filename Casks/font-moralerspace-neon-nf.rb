cask "font-moralerspace-neon-nf" do
    version :latest
    sha256 :no_check
  
    url "https://github.com/yuru7/moralerspace/releases/download/v#{version}/MoralerspaceNF_v#{version}.zip"
    name "Moralerspace Neon NF"
    homepage "https://github.com/yuru7/moralerspace"
  
    font "MoralerspaceNeonNF-Bold.otf"
    font "MoralerspaceNeonNF-BoldItalic.otf"
    font "MoralerspaceNeonNF-Italic.otf"
    font "MoralerspaceNeonNF-Regular.otf"
  end