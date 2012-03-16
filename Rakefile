require 'rubygems'
require 'date'
require 'rubygems/package_task'
 
GEM = 'apns'
GEM_NAME = 'apns'
GEM_VERSION = '0.9.2'
AUTHORS = ['James Pozdena']
EMAIL = "jpoz@jpoz.net"
HOMEPAGE = "http://github.com/jpoz/apns"
SUMMARY = "Simple Apple push notification service gem"
 
spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["MIT-LICENSE"]
  s.summary = SUMMARY
  s.description = <<-EOF
		The apns gem allows you to quickly and easily use the connect to APN servers
		to send push notification using Ruby. See http://github.com/jpoz/apns for more.
		EOF
  s.authors = AUTHORS
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.require_path = 'lib'
  # s.autorequire = GEM
  s.files = %w(MIT-LICENSE README.textile Rakefile) + Dir.glob("{lib}/**/*")
  s.add_runtime_dependency "json", ["~> 1.6"]
  s.add_development_dependency "rspec", ["~> 2.7"]
end
 
task :default => :spec
 
# desc "Run specs"
# Spec::Rake::SpecTask.new do |t|
#   t.spec_files = FileList['spec/**/*_spec.rb']
#   t.spec_opts = %w(-fs --color)
# end
#  
# Rake::GemPackageTask.new(spec) do |pkg|
#   pkg.gem_spec = spec
# end
 
desc "run specs"
task :specs do
	sh "spec #{FileList["spec/apns/*.rb"]}"
end

desc "install the gem locally"
task :install => [:package] do
  sh %{gem install #{GEM}-#{GEM_VERSION}}
end

task :update do
  sh "bundle install"
end

# task :gem => :update do
task :gem do
	sh "gem build apns.gemspec"
end

desc "build gem"
task :package => [:make_spec, :gem]

 
desc "create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end