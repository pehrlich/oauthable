# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "oauthable"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Peter Ehrlich"]
  s.date = "2012-02-17"
  s.description = "done omniauth callbacks"
  s.email = "peter.i.ehrlich@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "lib/oauthable.rb",
    "lib/oauthable/base.rb",
    "lib/oauthable/developer.rb",
    "lib/oauthable/facebook.rb",
    "lib/oauthable/google.rb",
    "lib/oauthable/railtie.rb",
    "lib/oauthable/twitter.rb",
    "test/helper.rb",
    "test/test_oauthable.rb"
  ]
  s.homepage = "http://github.com/pehrlich/oauthable"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.15"
  s.summary = "done omniauth callbacks"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["> 1.6.4"])
    else
      s.add_dependency(%q<bundler>, ["> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["> 1.6.4"])
    end
  else
    s.add_dependency(%q<bundler>, ["> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["> 1.6.4"])
  end
end
