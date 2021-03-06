# encoding: UTF-8

Gem::Specification.new do |s|
  s.platform     = Gem::Platform::RUBY
  s.name         = 'gaku_imex'
  s.version      = '0.3.0'
  s.summary      = 'Importers and Exporters for GAKU Engine'
  s.description  = "Importers and Exporters for GAKU Engine"
  s.required_ruby_version = '>= 2.1.3'

  s.authors      = ['Rei Kagetsuki', 'Georgi Tapalilov', 'Nakaya Yukiharu']
  s.email        = 'info@genshin.org'
  s.homepage     = 'http://github.com/GAKUEngine/gaku_imex'

  s.files = Dir.glob('lib/**/*.rb') +
            ['gaku_imex.gemspec']
  s.test_files = s.files.grep(/^spec\//)
  s.require_path = 'lib'

  s.requirements << 'postgres'
  s.requirements << 'redis'

  s.add_dependency 'gaku_core',    '~> 0.2.2'
  s.add_dependency 'gaku_testing', '~> 0.2.2'
  s.add_dependency 'gaku_admin',   '~> 0.2.2'

  s.add_dependency 'sidekiq'
  s.add_dependency 'sinatra'

  s.add_dependency 'smarter_csv'
  s.add_dependency 'thinreports-rails'

end
