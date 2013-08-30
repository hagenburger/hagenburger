require 'date'
require 'fileutils'
include FileUtils

module BlogHelper

  def slideshare id
    href = "http://static.slidesharecdn.com/swf/ssplayer2.swf?doc=#{id}&amp;rel=0"
    params = {
      'allowFullScreen' => true,
      'allowScriptAccess' => 'always',
      'movie' => href
    }.map{ |name, value| tag(:param, :name => name, :value => value) }.join
    embed = tag(:embed, :src => href, :type => 'application/x-shockwave-flash', :width => 420, :height => 360)
    %Q(<figure class="slideshare"><div><object>#{params}#{embed}</object></div></figure>)
  end

  def figure src, alt = nil
    %Q(<figure>) +
    %Q(<img src="#{src}" alt="#{alt || src.gsub('-', ' ').gsub(/\.\w+$/, '')}">) +
    (alt ? %Q(<figcaption>#{alt}</figcaption>) : '') +
    %Q(</figure>)
  end

  def article_img src, alt = nil
    %Q(<div class="image">) +
    %Q(<img src="#{src}" alt="#{alt || src.gsub('-', ' ').gsub(/\.\w+$/, '')}">) +
    %Q(</div>)
  end

end

