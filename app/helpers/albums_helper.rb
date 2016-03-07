module AlbumsHelper
  def current_url(new_params)
    params.merge!(new_params)
    string = params.map{ |k,v| "#{k}=#{v}" }.join("&")
    request.uri.split("?")[0] + "?" + string
  end
end
