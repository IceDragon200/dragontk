lib = File.join(File.dirname(__FILE__), 'lib')
$:.unshift lib unless $:.include?(lib)

require 'dragontk/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'dragontk'
  s.summary     = 'Helper code'
  s.description = 'Random helper tidbits by IceDragon'
  s.date        = Time.now.to_date.to_s
  s.version     = DragonTK::Version::STRING
  s.homepage    = 'https://github.com/IceDragon200/dragontk/'
  s.license     = 'MIT'

  s.authors = ['Corey Powell']
  s.email  = 'mistdragon100@gmail.com'

  s.add_dependency 'moon-logfmt',  '>= 1.1'

  s.add_dependency 'rubocop',      '~> 0.49'
  s.add_dependency 'rspec',        '~> 3.2'
  s.add_dependency 'simplecov',    '>= 0'
  s.add_dependency 'yajl-ruby',       '~> 1.2'

  s.add_dependency 'yard',         '~> 0.9.11'

  s.require_path = 'lib'
  s.executables = Dir.glob('bin/*').map { |s| File.basename(s) }
  s.files = ['Gemfile']
  s.files.concat(Dir.glob('{bin,lib,spec}/**/*'))
end
