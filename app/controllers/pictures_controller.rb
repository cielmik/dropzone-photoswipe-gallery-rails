class PicturesController < ApplicationController
  def destroy
    @album = Album.find(params[:album_id])
    picture = Picture.find(params[:id])
    if picture.destroy
      render json: { message: "file deleted from server" }
    end
  end
end
