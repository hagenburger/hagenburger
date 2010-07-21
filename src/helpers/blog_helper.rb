require 'date'
require 'fileutils'
include FileUtils

module BlogHelper

  class Post
    attr_accessor :title, :date, :permalink, :description
  end

  def blog posts_dir = "posts", max = 9999
    dir = File.join(Dir.getwd, 'src', 'pages', posts_dir)
    posts = []
    Dir["#{dir}/*.haml"].each do |file|
      if file =~ /\/([^\/_]+?)\.haml/
        haml = File.read(file)
        post = Post.new
        post.permalink = posts_dir + '/' + $1 + '.html'
        post.date = extract_instance_variable(haml, :date)
        post.title = extract_instance_variable(haml, :title)
        post.description = extract_instance_variable(haml, :description)
        posts << post
      end
    end
    posts = posts.sort_by{ |item| item.date }.reverse[0..max - 1]

    posts.each do |post|
      yield post
    end
  end

  def slideshare id
    href = "http://static.slidesharecdn.com/swf/ssplayer2.swf?doc=#{id}&amp;rel=0"
    tag(:figure, :class => 'slideshare') do
      tag(:div) do
        tag(:object) do
          {
            'allowFullScreen' => true,
            'allowScriptAccess' => 'always',
            'movie' => href
          }.map{ |name, value| tag(:param, :name => name, :value => value) }.join +
          tag(:embed, :src => href, :type => 'application/x-shockwave-flash', :width => 420, :height => 360)
        end
      end
    end
  end
  
  def figure src, alt = nil
    tag(:figure) do
      tag(:img, :src => src, :alt => alt || src.gsub('-', ' ').gsub(/\.\w+$/, '')) +
      (alt ? tag(:figcaption) { alt } : '')
    end
  end
  
  def article_img src, alt = nil
    tag(:div, :class => 'image') do
      tag(:img, :src => src, :alt => alt || src.gsub('-', ' ').gsub(/\.\w+$/, ''))
    end
  end

private

  def extract_instance_variable haml, var
    if haml =~ /@#{var} ?= ?(.+)/
      eval($1)
    end
  end

end
