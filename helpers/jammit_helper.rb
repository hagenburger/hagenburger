module JammitHelper

  def javascripts(*packages)
    packages.map do |pack|
      if ENV['MM_ENV'] == 'build'
        url = asset_url(Jammit.asset_url(pack, :js)[1..-1])
        %Q(<script src="#{url}"></script>\n)
      else
        Jammit.packager.individual_urls(pack.to_sym, :js).map do |file|
          url = file.gsub(%r(^.*build/), asset_url(''))
          %Q(<script src="#{url}"></script>\n)
        end.join
      end
    end.join
  end
  alias include_javascripts javascripts

end