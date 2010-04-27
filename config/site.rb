require 'compass'
require 'maruku'
require File.join(Dir.getwd, 'src', 'lib', 'haml_filters')
 
# Parse the Compass config
Compass.add_project_configuration('config/compass.rb')
 
# Default is 3000
configuration.preview_server_port = 3010

configuration.mime_types[:rss] = 'application/rss+xml'
configuration.mime_types[:xml] = 'application/xml'
 
# Default is localhost
configuration.preview_server_host = "localhost"
 
# Default is true
# When false .html & index.html get stripped off generated urls
configuration.use_extensions_for_page_links = true
 
# Default is an empty hash
# We use Compass's config
configuration.sass_options = Compass.sass_engine_options
Sass::Plugin.options[:template_location] = File.join(Dir.getwd, 'src', 'stylesheets')

# Default is an empty hash
# http://haml-lang.com/docs/yardoc/file.HAML_REFERENCE.html#options
configuration.haml_options = {
  :format => :html5,
  :attr_wrapper => '"'
}
