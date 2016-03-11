class PicturesController < ApplicationController
  def destroy
    picture = Picture.find(params[:id])
    if picture.destroy
      render json: { message: "file deleted from server" }
    end
  end
end
