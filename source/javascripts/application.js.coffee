# FONTS

try
  Typekit.load()
catch e


# BROWSER

$('html')
  .addClass(if $.browser.webkit then 'webkit' else if $.browser.msie then 'trident' else if $.browser.opera then 'presto' else if $.browser.mozilla then 'gecko' else null)
  .removeClass('no-js')


# PORTFOLIO

if $('#portfolio-carousel').length
  portfolioCurrentImage = -2
  portfolioImages       = $('#portfolio-carousel img')
  portfolioImagesSize   = portfolioImages.size()
  state                 = 1
  portfolioAnimation    = false

  portfolioImage = (index) ->
    if index < 0
      index += portfolioImagesSize
    else if index > portfolioImagesSize - 1
      index -= portfolioImagesSize
    $(portfolioImages.get(index))

  portfolioClick = (callback) ->
    unless portfolioAnimation
      portfolioAnimation = true
      if state > 3
        $("#portfolio-carousel figure:nth-child(" + (portfolioCurrentImage + 1) + ") figcaption").fadeOut()
        portfolioImage(portfolioCurrentImage - 1).animate({ opacity: 0, height: 0, left: "-123px" })
      if state > 2
        portfolioImage(portfolioCurrentImage).animate({ height: ["140px", "easeInSine"], left: ["-96px", "swing"] }, "normal", "easeOutQuint")
      if state > 1
        portfolioImage(portfolioCurrentImage + 1).animate({ height: ["320px", "easeOutSine"], left: ["200px", "swing"] }, "normal", "easeOutQuint")
      pi2 = portfolioImage(portfolioCurrentImage + 2)
      pi2.css({ right: "-123px", left: "auto", height: 0, opacity: 0, display: "block" })
      pi2.animate { opacity: 1, height: "140px", right: "-96px" }, () ->
        $(this).css({ left: "744px", right: null, opacity: null })
        portfolioAnimation = false
        if typeof callback == 'function'
          callback()

      portfolioCurrentImage++
      if portfolioCurrentImage > portfolioImagesSize - 1
        portfolioCurrentImage = 0
      if (state > 2)
        $("#portfolio-carousel figure:nth-child(" + (portfolioCurrentImage + 1) + ") figcaption").fadeIn()
      if (state < 4)
        state++

  $('#portfolio-carousel img').click(portfolioClick)

  portfolioClick () ->
    portfolioClick(portfolioClick)


# IE FIXES AND BEHAVIOURS

$('html').addClass('loaded')
if document.all
  $('.welcome--title').before '<div class="welcome--before"></div>'
button = $('.button button')
button.mouseenter () ->
  $(this).parent().parent().addClass 'hover'
button.mouseleave () ->
  $(this).parent().parent().removeClass 'hover active'
button.mousedown () ->
  $(this).parent().parent().addClass 'active'
button.mouseup () ->
  $(this).parent().parent().removeClass 'active'
button.focus () ->
  $(this).parent().parent().addClass 'focus'
button.blur () ->
  $(this).parent().parent().removeClass 'focus'


# COMMENTS

window.disqus_container_id = 'comments'
post = $('article.post')
if post.length == 1
  $('#content').append '<article id="' + disqus_container_id + '"></article>'
  $('#content').append '<div id="disqus_thread"></div>'

  date = $('meta[name="date"]').attr('content').split('-')
  year = date[0]
  month = date[1]
  day = date[2]
  slug = post.attr('data-slug') || location.href.replace(/^.+BLOG\/(.+)\.html$/, '$1')
  if year < 2010
    window.disqus_url = 'http://www.hagenburger.net/' + year + '/' + month + '/' + slug.toLowerCase()
  else
    window.disqus_url = 'http://www.hagenburger.net/' + location.href.replace(/^.+(BLOG\/(.+)\.html)$/, '$1')
    window.disqus_identifier = location.href.replace(/^.+(BLOG\/(.+)\.html)$/, '$1')
  console.log window.disqus_url
  window.disqus_developer = location.hostname == 'localhost' ? 1 : 0
  dsq = document.createElement('script')
  dsq.async = true
  dsq.src = 'http://hagenburger.disqus.com/embed.js'
  document.getElementsByTagName('head')[0].appendChild(dsq)

  links = document.getElementsByTagName('a')
  query = '?'
  for i in [0..links.length - 1]
    if links[i].href.indexOf('#disqus_thread') >= 0
      query += 'url' + i + '=' + encodeURIComponent(links[i].href) + '&'
  sc = document.createElement('script')
  sc.src = 'http://disqus.com/forums/hagenburger/get_num_replies.js' + query
  document.getElementsByTagName('head')[0].appendChild sc


# TO ALL THOSE GUYS WHO ARE TOO DUMP TO DOWNLOAD JQUERY AND USE MY CODE ;)

host = location.hostname
if host != 'localhost' and host != 'www.hagenburger.net' and host != 'nh.fornax.uberspace.de'
  location.href = "http://www.hagenburger.net/"


# ANALYTICS

$ () ->
  if location.hostname == 'www.hagenburger.net'
    $.gaTracker('UA-4797174-1')
    startTracking = () ->
      try
      catch e
      try
        piwikTracker = Piwik.getTracker("http://www.hagenburger.net/piwik/piwik.php", 1)
        piwikTracker.trackPageView()
        piwikTracker.enableLinkTracking()
      catch e
    setTimeout startTracking, 100


# ONLOAD

if typeof window.ol == 'function'
  $ window.ol
