Gem::Specification.new do |s|
  s.name    = "erubis-cached-text"
  s.version = "0.0.1"
  s.summary = "Eruby Engine that caches text strings in memory"
  s.author  = "Luke Gruber"
  s.email = 'luke.gru@gmail.com'
  s.homepage = 'https://github.com/luke-gru/erubis-cached-text'
  s.require_path = 'lib'
  s.files = Dir['README.md', 'LICENSE', 'VERSION', '.gitignore', 'Gemfile', 'lib/**/*', 'benchmark/**/*']

  s.add_runtime_dependency "erubis", "~> 2.7.0"
end
