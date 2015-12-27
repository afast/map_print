# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'map_print/version'

Gem::Specification.new do |spec|
  spec.name          = 'map_print'
  spec.version       = MapPrint::VERSION
  spec.authors       = ['Andreas Fast']
  spec.email         = ['andis.machine@gmail.com']

  spec.summary       = %q{Easily export maps to pdf}
  spec.description   = %q{MapPrint allows to export many map sources and GeoJSON objects to a pdf file, along with legend and text elements to create rich maps.}
  spec.homepage      = 'http://github.com/afast/map_print'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.8'
  spec.add_dependency 'prawn', '~> 2.0'
  spec.add_dependency 'prawn-fast-png', '~> 0.2.3'
  spec.add_dependency 'mini_magick', '~> 4.3'
  spec.add_dependency 'geo-distance', '~> 0.1'
  spec.add_dependency 'parallel', '~> 1.6'
  spec.add_dependency 'thor', '~> 0.19'
end
