module ::Tilt
  class LsgTemplate < RDiscountTemplate
    def prepare
      @outvar = options[:outvar] || self.class.default_output_variable
      @data = data
      @data = @data.force_encoding("UTF-8")
    end

    def evaluate(scope, locals, &block)
      markdown = render_erb(@data, scope)
      html = render_markdown(markdown)
      convert_line_breaks(html)
    end

    def initialize_engine
      super
      return if defined? ::ERB
      require_template_library 'erb'
    end

    private
    def render_erb(erb, scope)
      erb = ::ERB.new(erb, options[:safe], options[:trim], @outvar).src
      scope.instance_eval(erb, eval_file, 1)
    end

    private
    def render_markdown(markdown)
      format_info(markdown)
      renderer = LivingStyleGuide::RedcarpetHTML.new
      redcarpet = ::Redcarpet::Markdown.new(renderer, LivingStyleGuide::REDCARPET_RENDER_OPTIONS)
      redcarpet.render(markdown)
    end

    private
    def format_info(markdown)
      markdown.gsub! /^@info (.+?)$/ do
        %Q(<div class="info"><div class="info--text">#{$1}</div></div>\n)
      end
    end

    private
    def convert_line_breaks(html)
      html.gsub %r((<pre class="livingstyleguide--code-block"><code class="livingstyleguide--code">)(.+?)(</code></pre>))m do |match|
        match.gsub("\n", '&#x000A;')
      end
    end
  end

  register 'lmd', LsgTemplate
end

