cask "font-moralerspace-neon-nf" do
    version "0.0.8"
    sha256 "ad7b412fd05817c39f506ebe942b9e527504b626bae80b8cce866cd7eae9d99c"
  
    url "https://github.com/yuru7/moralerspace/releases/download/v#{version}/MoralerspaceNF_v#{version}.zip"
    name "Moralerspace Neon NF"
    desc "Moralerspace is a programming font that combines Monaspace and IBM Plex Sans JP"
    homepage "https://github.com/yuru7/moralerspace"

    livecheck do
        url "https://github.com/yuru7/moralerspace.git"
    end
  
    font "MoralerspaceNF_v#{version}/MoralerspaceNeonNF-Bold.ttf"
    font "MoralerspaceNF_v#{version}/MoralerspaceNeonNF-BoldItalic.ttf"
    font "MoralerspaceNF_v#{version}/MoralerspaceNeonNF-Italic.ttf"
    font "MoralerspaceNF_v#{version}/MoralerspaceNeonNF-Regular.ttf"
end