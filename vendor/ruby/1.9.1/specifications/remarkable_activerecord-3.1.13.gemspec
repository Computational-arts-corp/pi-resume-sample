# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "remarkable_activerecord"
  s.version = "3.1.13"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Carlos Brando", "Jos\u{c3}\u{a9} Valim", "Diego Carrion"]
  s.date = "2010-02-18"
  s.description = "Remarkable ActiveRecord: collection of matchers and macros with I18n for ActiveRecord"
  s.email = ["eduardobrando@gmail.com", "jose.valim@gmail.com", "dc.rec1@gmail.com"]
  s.extra_rdoc_files = ["README", "LICENSE", "CHANGELOG"]
  s.files = ["README", "LICENSE", "CHANGELOG"]
  s.homepage = "http://github.com/carlosbrando/remarkable"
  s.require_paths = ["lib"]
  s.rubyforge_project = "remarkable"
  s.rubygems_version = "1.8.23"
  s.summary = "Remarkable ActiveRecord: collection of matchers and macros with I18n for ActiveRecord"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rspec>, [">= 1.2.0"])
      s.add_runtime_dependency(%q<remarkable>, ["~> 3.1.13"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.0"])
      s.add_dependency(%q<remarkable>, ["~> 3.1.13"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.0"])
    s.add_dependency(%q<remarkable>, ["~> 3.1.13"])
  end
end