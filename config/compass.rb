ROOT = File.join(File.dirname(__FILE__), '/')
puts "Site root is: " + File.expand_path(ROOT)

require "redgreengrid" # version > 0.3.2

output_style     = ARGV[0] == 'build' ? :compressed : :expanded
project_path     = ROOT
sass_dir         = "../src/stylesheets"
http_path        = "../"
css_dir          = "../site/stylesheets"
images_dir       = "../site/images"
http_images_path = "../images"
