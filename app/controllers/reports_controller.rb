class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource 
  skip_load_resource only: [:create] 
  skip_before_filter :verify_authenticity_token

  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.all
    @reports.each do |report|
      report.can_edit = can?(:edit,report) 
      report.can_read = can?(:read,report)
      report.can_destroy = can?(:destroy,report)
    end
    render json: @reports
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @comment = Comment.new
    @report.can_edit = can?(:edit,@report) 
    @report.can_read = can?(:read,@report)
    @report.can_destroy = can?(:destroy,@report)
    render json: @report

  end

  # GET /reports/new
  # def new
  #   @report = Report.new
  # end

  # # GET /reports/1/edit
  # def edit
  # end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.create(report_params.merge({user: current_user}))

    # respond_to do |format|
    #   if @report.save
    #     format.html { redirect_to @report, notice: 'Report was successfully created.' }
    #     format.json { render action: 'show', status: :created, location: @report }
    #   else
    #     format.html { render action: 'new' }
    #     format.json { render json: @report.errors, status: :unprocessable_entity }
    #   end
    # end
    render json: @report
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    @report.update(report_params)
    render nothing: true
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.update(editor: nil, destroyer: current_user)
    @report.destroy
    render nothing: true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:title, :description, :category_id).merge({editor: current_user})
    end
end
