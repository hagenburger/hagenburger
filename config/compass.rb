ROOT = File.join(File.dirname(__FILE__), '/')
puts "Site root is: " + File.expand_path(ROOT)

require "redgreengrid" # version > 0.3.2
 
output_style = :compressed
project_path = ROOT               # must be set for Compass to work 
sass_dir     = "stylesheets"  # dir containing Sass / Compass source files
http_path    = "/"                # root when deployed
css_dir      = "../site/stylesheets" # final CSS
images_dir   = "../site/images"      # final images
http_images_path = "../images"
