class PicturesController < ApplicationController
  def index
    @pictures = Picture.all
  end

  def edit
    @picture = Picture.find(params[:id])
  end

  def destroy
    picture = Picture.find(params[:id])
    if picture.destroy
      render json: { message: "file deleted from server" }
    end
  end
end
