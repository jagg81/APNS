# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{apns}
  s.version = "0.9.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{James Pozdena}]
  s.date = %q{2012-03-14}
  s.description = %q{		The apns gem allows you to quickly and easily use the connect to APN servers
		to send push notification using Ruby. See http://github.com/jpoz/apns for more.
}
  s.email = %q{jpoz@jpoz.net}
  s.extra_rdoc_files = [%q{MIT-LICENSE}]
  s.files = [%q{MIT-LICENSE}, %q{README.textile}, %q{Rakefile}, %q{lib/apns}, %q{lib/apns/core.rb}, %q{lib/apns/notification.rb}, %q{lib/apns.rb}]
  s.homepage = %q{http://github.com/jpoz/apns}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Simple Apple push notification service gem}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, ["~> 1.6"])
      s.add_development_dependency(%q<rspec>, ["~> 2.7"])
    else
      s.add_dependency(%q<json>, ["~> 1.6"])
      s.add_dependency(%q<rspec>, ["~> 2.7"])
    end
  else
    s.add_dependency(%q<json>, ["~> 1.6"])
    s.add_dependency(%q<rspec>, ["~> 2.7"])
  end
end
