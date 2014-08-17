# encoding: utf-8

require "bundler"
Bundler.setup

require 'rdiscount'
require File.join(Dir.getwd, 'lib', 'haml_filters')
require File.join(Dir.getwd, 'lib', 'syntax_highlighter')
require File.join(Dir.getwd, 'lib', 'string')
require File.join(Dir.getwd, 'lib', 'markdown')

::Compass.add_project_configuration('compass.rb')

activate :automatic_image_sizes

configure :build do
  activate :minify_css
  #activate :smush_pngs
  activate :cache_buster
  activate :relative_assets
end

activate :blog do |blog|
  blog.permalink = ':title.html'
  blog.prefix = 'BLOG'
end

page '/PHOTOGRAPHY/beijing.html', :layout => :beijing, :layout_engine => :haml
page '/PHOTOGRAPHY/kino-international-euruko.html', :layout => :images, :layout_engine => :haml
page '/BLOG/*', :layout => :layout, :layout_engine => :haml
page '/*.rss', :layout => false
page '/*.xml', :layout => false

::Compass::configuration.asset_cache_buster = :none
set :haml, { :attr_wrapper => '"', :format => :html5 }

require 'minisyntax'
require 'tilt'
require 'erb'
require 'compass'
module ::Tilt
  class MdErbTemplate < RDiscountTemplate
    def prepare
      @outvar = options[:outvar] || self.class.default_output_variable
      @data = data
      @data = @data.force_encoding("UTF-8")
    end

    def evaluate(scope, locals, &block)
      # filter CSS and JavaScript
      @data.gsub! %r(^<style type="text/s?css">(.+?)</style>$)m do
        css = %Q(@import "compass"; #{$1})
        sass_options = ::Compass.configuration.to_sass_engine_options
        sass_options.merge! :syntax => :scss, :style => :compressed
        css = Sass::Engine.new(css, sass_options).render
        scope.instance_eval("@css ||= ''\n@css << %q(#{css})", eval_file, 1)
        ''
      end
      @data.gsub! %r(^<script>(.+?)</script>$)m do
        javascript = $1
        scope.instance_eval("@javascript ||= ''\n@javascript << %q(#{javascript})", eval_file, 1)
        ''
      end

      erb = ::ERB.new(@data, options[:safe], options[:trim], @outvar).src
      md = scope.instance_eval(erb, eval_file, 1)
      # Maruku’s HTML parser is a bad idea.
      # md = Maruku.new(md).to_html
      md = RDiscount.new(md)
      md.filter_html = false
      md.filter_styles = false
      html = md.to_html

      # syntax highlighter
      html.gsub! %r(<code>(.+?)</code>)m do
        code = $1
        if code =~ /^##+\s*([-_\w\+ ]+)[\s#]*(\n|&#x000A;|$)/i
          lang = $1
          code.sub! /^##+\s*([-_\w\+ ]+)[\s#]*(\n|&#x000A;|$)/i, ''
          #code.gsub! '&amp;', '&'
          code = MiniSyntax.highlight(code, lang)
          #code.gsub! '&', '&amp;'
          #code.gsub! /&amp;(\w+;)/, '&\\1'
        end
        code.gsub! "\n", '&#x000A;'
        %Q(<code>#{code}</code>)
      end

      # allow <dl>s (not implemented in RDiscount)
      html.gsub! %r(<p>(.+?)\n:\s+(.+?)</p>), "  <dt>\\1</dt>\n  <dd>\\2</dd>"
      html.gsub! %r((</(p|div|figure|h1|h2|table|pre)>\n+)  <dt>)m, "\\1<dl>\n  <dt>"
      html.gsub! %r(</dd>\n\n<)m, "</dd>\n</dl>\n<"

      # remove uglyness and create beautiful HTML5
      html.gsub! %r(<p><figure), '<figure'
      html.gsub! %r(</figure></p>), '</figure>'
      html.gsub! /\n\n/, "\n"
      html.gsub! /([^>])\n/, '\\1 '
      html.gsub! /<h2 id='_?(.+?)_?'>(.+?)<\/h2>/ do
        text = $2
        "<h2 id=\"#{ $1.gsub('_', '-') }\">#{ text }</h2>"
      end
      html.gsub! %r(<h2>(.+?)</h2>) do
        headline = $1
        id = headline.gsub(/<.+?>/, '').gsub(/\(.+?\)/, '').gsub('Update:', '').gsub(/^\d+\. /, '').strip.to_slug
        %Q(<h2 id="#{id}">#{headline}</h2>)
      end
      html.gsub! /<li>/, '  \\0'
      html.gsub! " style='text-align: left;'", ''
      html.gsub! /<(\w+)( (\w+)='(.+?)')>/ do
        "<#{ $1 }#{ $2.gsub('\'', '"') }>"
      end
      html.gsub! /<img(.+?) ?\/>/, '<img\\1>'

      # fix image URLs
      html.gsub! 'images/images', 'images'

      html
    end

    def initialize_engine
      super
      return if defined? ::ERB
      require_template_library 'erb'
    end
  end
  %w(mderb rmd).each do |ext|
    register ext, MdErbTemplate
  end
end

# some magic to get the best indented HTML5 ever ;)
require 'rack/utils'
module ::Rack
  class CleanUp
    include Rack::Utils

    def initialize(app, options = {})
      @app = app
      @options = options
    end

    def call(env)
      status, headers, response = @app.call(env)
      headers = HeaderHash.new(headers)

      if !STATUS_WITH_NO_ENTITY_BODY.include?(status) and
         !headers['transfer-encoding'] and
         headers['content-type'] and
         headers['content-type'].include?("text/html")

        content = ""
        response.each { |part| content += part }
        content.gsub! %r(\n(\s*\n)+), "\n"
        content.gsub! %r(<((img|link|meta|hr|br).*?) ?/>), '<\\1>'
        content_tmp = ''
        indent = 0
        failure_indent = 999
        failure = 0
        tag_name = ''
        content.each_line do |line|
          line =~ %r(^( *)([</]([\w\*]+))?.+?(</(\1)>)?)
          current_indent = $1.length
          current_tag_name = $3
          additional_indent = (%w(img meta link h1 *).include?(tag_name) ) ? 0 : 2
          if current_indent > indent + additional_indent
            failure = current_indent - indent - additional_indent
            failure_indent = current_indent - additional_indent
          elsif failure_indent > current_indent
            failure = 0
            failure_indent = 999
          end
          line.gsub! /^#{' ' * failure}/, '' if failure
          indent = current_indent
          tag_name = current_tag_name
          content_tmp << line
        end
        content = content_tmp
        headers['content-length'] = bytesize(content).to_s

        [status, headers, [content]]
      else
        [status, headers, response]
      end
    end
  end
end
use ::Rack::CleanUp


# Automatic sitemaps
# activate :slickmap

# CodeRay syntax highlighting in Haml
# activate :code_ray

# Automatic image dimension calculations
# activate :automatic_image_sizes

# Per-page layout changes
# With no layout
# page "/path/to/file.html", :layout => false
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout

# Helpers

require File.join(Dir.getwd, 'helpers', 'blog_helper')
require 'open-uri'
helpers do
  include BlogHelper

  def compress_javascript(javascript)
    compressor = ::YUI::JavaScriptCompressor.new(:munge => true)
    compressor.compress(javascript)
  end

  def facebook_like(url = nil)
    url ||= %Q(http://www.hagenburger.net/#{request.path})
    url = URI::encode(url)
    %Q(<iframe class="like" src="http://www.facebook.com/plugins/like.php?href=#{url}&amp;width=420" scrolling="no" frameborder="0" allowTransparency="true"></iframe>)
  end

  def dribbble_shots
    require 'simple-rss'
    require 'open-uri'
    rss = SimpleRSS.parse(open('http://dribbble.com/hagenburger/shots.rss'))
    rss.channel.items
  rescue
    []
  end
end


# Change the CSS directory
# set :css_dir, "alternative_css_directory"



# Change the JS directory
# set :js_dir, "alternative_js_directory"



# Change the images directory
# set :images_dir, "alternative_image_directory"


# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Shrink/smush PNG/JPEGs on build
  # activate :smush_pngs

  # Enable cache buster
  # activate :cache_buster

  # Generate ugly/obfuscated HTML from Haml
  # activate :ugly_haml


  # Or use a different image path
  # set :http_path, "/Content/images/"
end
