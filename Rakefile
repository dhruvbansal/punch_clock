$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

desc "Build punch clock gem "
task :build do
  system "gem build punch_clock.gemspec"
end

version = File.read(File.expand_path('../VERSION', __FILE__)).strip
desc "Install punch_clock-#{version}"
task :install => :build do
  system "gem install punch_clock-#{version}.gem"
end
