# encoding: utf-8

require "bundler"
Bundler.setup

ssh_user = "nico@hagenburger.net"
production_url = "http://www.hagenburger.net/"
production_path = "/home/web/hagenburger/"

desc "Builds the site with bundler"
task :build do
  puts "Building the site"
  system "bundle exec middleman build"

  # fix wrong image urls
  Dir.glob 'build/**/*.css' do |file|
    css = File.read(file)
    File.open(file, 'w') do |file|
      css.gsub! '../../images', '../images'
      css.gsub! /(\.png|\.jpg)\?\d+/, '\\1'
      file.write css
    end
  end
  Dir.glob '**/*.html' do |file|
    html = File.read(file)
    File.open(file, 'w') do |file|
      html.gsub! 'images/images', 'images'
      file.write html
    end
  end
end

desc "Deploys the site to #{production_url}"
task :deploy => :build do
  puts "Deploying the site to #{production_url}"
  system("rsync -avz build/ #{ssh_user}:#{production_path}")
end
