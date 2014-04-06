class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :set_report
  load_and_authorize_resource 
  skip_load_resource only: [:create]

  def index
    @report.comments.each do |comment|
      comment.can_edit = can?(:edit,comment) 
      comment.can_destroy = can?(:destroy,comment)
      comment.updated = comment.updated?
      comment.author_name = comment.user.name
    end
    render json: @report.comments
  end

  def create
    @comment = Comment.create(comment_params)
    @comment.can_edit = can?(:edit, @comment) 
    @comment.can_destroy = can?(:destroy, @comment)
    @comment.updated = @comment.updated?
    @comment.author_name = @comment.user.name
    render json: @comment
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

