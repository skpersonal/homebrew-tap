cask "font-source-han-code-jp" do
    version "2.012R"
    sha256 :no_check
  
    url "https://github.com/adobe-fonts/source-han-code-jp/archive/refs/tags/#{version}.zip"
    name "Source Han Code JP"
    desc "Source Han Code JP | 源ノ角ゴシック Code"
    homepage "https://github.com/adobe-fonts/source-han-code-jp"
  
    font "source-han-code-jp-#{version}/OTC/SourceHanCodeJP.ttc"
end