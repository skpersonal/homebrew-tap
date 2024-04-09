cask "font-source-han-code-jp" do
    version "2.012R"
    sha256 "1d0438f0623be0761d5ffb105f61767bd7f2b71fbc95dafd00bee9a332f62585"
  
    url "https://github.com/adobe-fonts/source-han-code-jp/archive/refs/tags/#{version}.zip"
    name "Source Han Code JP"
    desc "Source Han Code JP | 源ノ角ゴシック Code"
    homepage "https://github.com/adobe-fonts/source-han-code-jp"
  
    font "source-han-code-jp-#{version}/OTC/SourceHanCodeJP.ttc"
end
