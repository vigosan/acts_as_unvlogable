# ----------------------------------------------
#  Class for Youtube (youtube.com)
#  http://www.youtube.com/watch?v=25AsfkriHQc
# ----------------------------------------------


class VgYoutube
  
  def initialize(url=nil, options={})
    # general settings
    settings ||= YAML.load_file(RAILS_ROOT + '/config/unvlogable.yml') rescue {}
    object = YouTube::Client.new(options.nil? || options[:key].nil? ? settings['youtube_key'] : options[:key]) rescue {}
    
    @url = url
    @video_id = parse_url(url)
    @details = object.video_details(@video_id)
  end
  
  def title
    @details.title
  end
  
  def thumbnail
    @details.thumbnail_url
  end
  
  def embed_url
    "http://www.youtube.com/v/#{@video_id}" if @details.embed_allowed == true
  end
  
  def embed_html(width=425, height=344, options={})
    "<object width='#{width}' height='#{height}'><param name='movie' value='#{embed_url}&fs=1'></param><param name='allowFullScreen' value='true'></param><param name='allowscriptaccess' value='always'></param><embed src='#{embed_url}&fs=1' type='application/x-shockwave-flash' allowscriptaccess='always' allowfullscreen='true' width='#{width}' height='#{height}'></embed></object>" if @details.embed_allowed == true
  end
  
  
  def flv
    doc = URI::parse(@url).read
    t = doc.split("&t=")[1].split("&")[0]
    "http://www.youtube.com/get_video.php?video_id=#{@video_id}&t=#{t}"
  end
  
  private
  
  def parse_url(url)
    uri = URI.parse(url)
    args = uri.query
    video_id = ''
    if args and args.split('&').size >= 1
      args.split('&').each do |arg|
        k,v = arg.split('=')
        video_id = v and break if k == 'v'
      end
      raise unless video_id
    else
      raise
    end
    video_id
  rescue
    nil    
  end
  
end