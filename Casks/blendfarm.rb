cask 'blendfarm' do
  version 'v1.1.6'
  sha256 'bf6eb1b3df958f43824488d8d54f41ded90c5d8160adbd665c7b290566d12bd9'
  url "https://github.com/LogicReinc/LogicReinc.BlendFarm/releases/download/#{version}/BlendFarm-#{version.slice(/[0-9.]+/)}-OSX64.zip"
  name 'LogicReinc.BlendFarm'
  desc 'A stand-alone Blender Network Renderer'
  homepage 'https://github.com/LogicReinc/LogicReinc.BlendFarm'

  app "BlendFarm-#{version.slice(/[0-9.]+/)}-OSX64/LogicReinc.BlendFarm.app"
end
