cask "font-moralerspace-neon" do
    version ""
    sha256 ""
  
    url "https://github.com/yuru7/moralerspace/releases/download/#{version}/Moralerspace_#{version}.zip"
    name "Moralerspace Neon"
    desc "Moralerspace is a programming font that combines Monaspace and IBM Plex Sans JP"
    homepage "https://github.com/yuru7/moralerspace"
  
    font "Moralerspace_#{version}/MoralerspaceNeon-Bold.ttf"
    font "Moralerspace_#{version}/MoralerspaceNeon-BoldItalic.ttf"
    font "Moralerspace_#{version}/MoralerspaceNeon-Italic.ttf"
    font "Moralerspace_#{version}/MoralerspaceNeon-Regular.ttf"
end
