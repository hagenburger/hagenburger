module JavaScriptHelper
  
  def javascripts_compressed *args
    destination = args.shift + '.js'
    destination_path = File.join(Dir.getwd, 'site', destination)
    last_modified = File.mtime(destination_path) rescue Time.mktime(1970, 1, 1)
    if args.map{ |source| File.mtime(File.join(Dir.getwd, 'src', 'javascripts', source + '.js')) > last_modified }.include?(true)
      open destination_path, 'w' do |file|
        args.each do |source|
          file << `java -jar ~/.bin/yuicompressor-2.4.2.jar #{ File.join(Dir.getwd, 'src', 'javascripts', source + '.js') }`
        end
      end
    end
    tag(:script, :src => "#{ current_page_relative_path }#{ destination }") { '' }
  end
  
end