cask 'font-source-han-code-jp' do
  version '2.012R'
  sha256 'bedc74973220f1ce4bb16e1fa64a46604c3164bf95b62fa48c8a046dd468d6ef'

  url "https://github.com/adobe-fonts/source-han-code-jp/archive/refs/tags/#{version}.zip"
  name 'Source Han Code JP'
  desc 'Source Han Code JP | 源ノ角ゴシック Code'
  homepage 'https://github.com/adobe-fonts/source-han-code-jp'

  font "source-han-code-jp-#{version}/OTC/SourceHanCodeJP.ttc"
end
