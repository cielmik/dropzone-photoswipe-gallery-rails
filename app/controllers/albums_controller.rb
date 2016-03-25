class AlbumsController < ApplicationController
  def index
    @albums = Album.all
    @pictures = Picture.all
  end

  # localhost:3000/albums/1/image_list.json, this is
  # for dropzone thumbnail previews
  def image_list
    @images = Picture.where(album_id: params[:album_id])
    respond_to do |format|
      format.json { render json: @images.to_json(methods: [:path])}
    end
  end

  def new
    @album = Album.new
  end

  def create
    @album = Album.create(album_params)
    respond_to do |format|
      if @album.save
        format.html { redirect_to root_path, notice: 'Album was successfully created.' }
        format.js
        format.json { render json: { message: "success", fileID: @album.id}, :status => 200 }
      else
        render 'new'
      end
    end
  end

  def edit
    @album = Album.find(params[:id])
  end

  def update
    @album = Album.find(params[:id])
    respond_to do |format|
      if @album.update_attributes(album_params)
        format.html { redirect_to root_path, notice: 'Album was successfully created.' }
        format.json { render json: @album  }
        format.js {}
      else
        flash[:danger] = "Album has not been saved."
        render 'new'
      end
    end
  end

  def destroy
    @album = Album.find(params[:id])
    if @album.destroy
      flash[:notice] = "Album has been deleted"
      redirect_to root_path
    end
  end

  def show
    @album = Album.find(params[:id])
      respond_to do |format|
        format.json { render json: @album }
      end
  end

  private

  def album_params
    params.require(:album).permit(:name,:title,:description).tap do |whitelisted|
      whitelisted[:images] = params[:album][:images]
    end
  end
end
