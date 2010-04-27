// FONTS

try {
  Typekit.load();
}
catch(e) {}

// BROWSER CLASS

$('html').addClass($.browser.webkit ? 'webkit' : $.browser.msie ? 'trident' : $.browser.opera ? 'presto' : $.browser.mozilla ? 'gecko' : null);

// PORTFOLIO

$(function() {
  if ($('#portfolio-carousel').length) {
    var portfolioCurrentImage = -2,
        portfolioImages       = $('#portfolio-carousel img'),
        portfolioImagesSize   = portfolioImages.size();
        state                 = 1,
        portfolioAnimation    = false;

    var portfolioImage = function(index) {
      if (index < 0) index += portfolioImagesSize;
      else if (index > portfolioImagesSize - 1) index -= portfolioImagesSize;
      return $(portfolioImages.get(index));
    };

    var portfolioClick = function() {
      if (!portfolioAnimation) {
        portfolioAnimation = true;
        if (state > 3) {
          $("#portfolio-carousel figure:nth-child(" + (portfolioCurrentImage + 1) + ") figcaption").fadeOut();
          portfolioImage(portfolioCurrentImage - 1)
            .animate({ opacity: 0, height: 0, left: "-123px" });
        }
        if (state > 2) {
          portfolioImage(portfolioCurrentImage)
            .animate({ height: ["140px", "easeInSine"], left: ["-96px", "swing"] }, "normal", "easeOutQuint");
        }
        if (state > 1) {
          portfolioImage(portfolioCurrentImage + 1)
            .animate({ height: ["320px", "easeOutSine"], left: ["200px", "swing"] }, "normal", "easeOutQuint");
        }
        portfolioImage(portfolioCurrentImage + 2)
          .css({ right: "-123px", left: "auto", height: 0, opacity: 0 })
          .animate({ opacity: 1, height: "140px", right: "-96px" }, function() {
            $(this).css({ left: "744px", right: null, opacity: null });
            portfolioAnimation = false;
          });
      
        portfolioCurrentImage++;
        if (portfolioCurrentImage > portfolioImagesSize - 1) portfolioCurrentImage = 0;
        if (state > 2)
          $("#portfolio-carousel figure:nth-child(" + (portfolioCurrentImage + 1) + ") figcaption").fadeIn();  

        if (state < 4) state++;
      }
    }

    $('#portfolio-carousel img').click(portfolioClick);

    portfolioClick();
    setTimeout(portfolioClick, 450);
    setTimeout(portfolioClick, 900);
  }
});

// IE FIXES AND BEHAVIOURS

$.each("header nav article section footer aside time figure figcaption".split(" "), function(i, element) {
  document.createElement(element);
});

$(function() {
  if (document.all) {
    $('#welcome h1').before('<div id="welcome-before"></div>');
  }
  $('.button button').mouseenter(function() {
    $(this).parent().parent().addClass('hover');
  }).mouseleave(function() {
    $(this).parent().parent().removeClass('hover active');
  }).mousedown(function() {
    $(this).parent().parent().addClass('active');
  }).mouseup(function() {
    $(this).parent().parent().removeClass('active');
  }).focus(function() {
    $(this).parent().parent().addClass('focus');
  }).blur(function() {
    $(this).parent().parent().removeClass('focus');
  });
});

// COMMENTS

var disqus_url, disqus_identifier, disqus_container_id = 'comments';
$(function() {
  var post = $('article.post');
  if (post.length == 1) {
    $('#content').append('<article id="' + disqus_container_id + '"></article>');
    
    var date = $('html').attr('data-date').split('-');
    var year = date[0], month = date[1], day = date[2];
    if (year < 2010) {
      var slug = post.attr('data-slug') || location.href.replace(/^.+BLOG\/(.+)\.html$/, '$1');
      disqus_url = 'http://www.hagenburger.net/' + year + '/' + month + '/' + slug.toLowerCase();
    }
    else {
      disqus_identifier = slug;
    }
    var disqus_developer = location.hostname == 'localhost' ? 1 : 0;
    var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
    dsq.src = 'http://hagenburger.disqus.com/embed.js';
    document.getElementsByTagName('head')[0].appendChild(dsq);
    
    var links = document.getElementsByTagName('a');
    var query = '?';
    for(var i = 0; i < links.length; i++) {
    if(links[i].href.indexOf('#disqus_thread') >= 0) {
      query += 'url' + i + '=' + encodeURIComponent(links[i].href) + '&';
    }
    }
    var sc = document.createElement('script');
    sc.type = 'text/javascript';
    sc.src = 'http://disqus.com/forums/hagenburger/get_num_replies.js' + query;
    document.getElementsByTagName('body')[0].appendChild(sc);
  }
  
});

// ANALYTICS

if (location.hostname != 'localhost' && !location.href.match(/\/test\//)) {
  $.gaTracker('UA-4797174-1');
}