Gem::Specification.new do |s|
  s.name    = "erubis-cached-text"
  s.version = "0.0.1"
  s.summary = "Eruby Engine that caches text strings in memory"
  s.author  = "Luke Gruber"

  s.files = Dir.glob("lib/**/*.rb")

  s.add_runtime_dependency "erubis", "~> 2.7.0"
end
