require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "wp2mt"
    gem.summary = %Q{Small gem to dump a Wordpress database into a MovableType importable file format }
    gem.description = %Q{Small gem to dump a Wordpress database into a MovableType importable file format}
    gem.email = "inffcs00@gmail.com"
    gem.homepage = "http://github.com/inffcs00/wp2mt"
    gem.authors = ["Felix Cachaldora"]
    gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end


require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "wp2mt #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
