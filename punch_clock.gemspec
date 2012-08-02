root = File.expand_path('../', __FILE__)
lib  = File.join(root, 'lib')
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name         = 'punch_clock'
  s.version      = File.read(File.join(root, 'VERSION')).strip
  s.platform     = Gem::Platform::RUBY
  s.authors      = ['Dhruv Bansal']
  s.email        = ['shrub.vandal@gmail.com']
  s.homepage     = 'http://github.com/dhruvbansal/punch_clock'
  s.summary      = "A minimal command-line punch clock."
  s.description  = "Provides a simple and minimal command-line program called `punch' which lets you track when you're working."
  s.files        = Dir["{bin,lib,spec}/**/*"] + %w[LICENSE README.rdoc VERSION]
  s.executables  = ['punch']
  s.require_path = 'lib'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'ZenTest'
end
