class PicturesController < ApplicationController
  before_action :set_picture, except: [:create, :index]
  before_action :set_report

  def index
    @pictures = @report.pictures
    @picture = @report.pictures.new
  end

  def create
    @report.pictures << Picture.create(picture_attributes)
    redirect_to report_pictures_path(@report)
  end

  def destroy
    @picture.destroy
    redirect_to report_pictures_path(@report)
  end

  def show 
    @picture = Picture.find(params[:id])
    index = @report.pictures.index(@picture)
    size = @report.pictures.size
    @next = index == size-1 ? nil : @report.pictures[index+1]
    @previous = index == 0 ? nil : @report.pictures[index-1]
    render layout: false
  end

  private
    def set_picture
      @picture = Picture.find(params[:id])
    end

    def set_report
      @report = Report.find(params[:report_id])
    end

    def picture_attributes
      params.require(:picture).permit(:image) if params.has_key?(:picture)
    end
end