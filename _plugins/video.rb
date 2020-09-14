class Video < Jekyll::Generator
  def generate(site)
    other_resolutions = []
    docs = site.posts.docs

    docs.each do |post|
      data = post.data
      video = data['video']
      next unless video

      default_res = video.keys.first
      title = data['title']
      permalink = title.downcase.gsub(' ', '-')

      data['current_resolution'] = default_res
      data['permalink'] = "#{permalink}/#{default_res}"

      video.each do |res, _|
        res_post = Jekyll::Document.new(post.path, site: site, collection: post.collection)
        res_post.read

        res_data = res_post.data
        res_data['current_resolution'] = res
        res_data['permalink'] = "#{permalink}/#{res}"
        res_data['unlisted'] = true

        other_resolutions << res_post
      end
    end

    docs.concat(other_resolutions)
  end
end
