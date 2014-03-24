class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :set_report
  load_and_authorize_resource 
  skip_load_resource only: [:create]

  def edit
    respond_to do |format|
      format.js
    end
  end

  def create
    @comment = Comment.new(comment_params)
    if (user_signed_in?) && @comment.save
      respond_to do |format|
        format.js
      end
    end
  end

  def update
    if @comment.update(comment_params)
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.js
    end
  end

  private

    def set_comment
      @comment = Comment.find(params[:id])
    end

    def set_report
      @report = Report.find(params[:report_id])
    end

    def comment_params
      parameters = params.require(:comment).permit(:text)
      parameters.merge!({report_id: @report.id})
      parameters.merge!({user_id: current_user.id})
      parameters
    end
end

