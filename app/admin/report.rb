ActiveAdmin.register Report do
menu priority: 4
permit_params :title, :description, :user_id, :category_id

#belongs_to :user
#http://localhost:3000/admin/users/:user_id/reports/:report_id - show route


#ERROR:No route matches {:action=>"index", :controller=>"admin/reports"} missing required keys: [:user_id]
#get "/admin/reports" => 'admin/reports#show_all', as: "admin_reports"

# controller do 
#   def show_all
#     @reports = Report.all.page(params[:page]).per(10)
#     render :index, :layout => false
#   end
# end


# collection_action :show_all do 
#   @reports = Report.all.page(params[:page]).per(10)
#   render action: 'index', :layout => false
# end
#/admin/users/:user_id/reports/show_all


# collection_action :show_from_autor do
#   @reports = Report.where(user_id: params[:user_id]).page(params[:page]).per(10)
#   render action: 'index', :layout => false
# end
# #/admin/reports/show_from_autor
#get "/admin/reports/show_from_autor/:user_id" => 'admin/reports#show_from_autor', as: "show_from_autor_admin_reports"
# # Can't add param :user_id

# controller do
#     def show_from_autor
#       @reports = Report.where(user_id: params[:user_id]).page(params[:page]).per(10)
#       render action: 'index', :layout => false
#     end
#   end



  #Ако искам user/:id/reports и reports да изглеждат еднакво (Много играчка да се докара дизайн)
  # index do 
  #     render partial: "index", locals: {reports: reports}
  # end


  # controller do

    # collection_action :set_user do
    #   @report = Report.new(user: User.last)
    #   render action: "new", :layout => false
    # end
  # end

  controller do
    after_action :send_user_msg, only: [:update, :destroy]
    before_action :set_user_msg, only: [:update, :destroy]

    def send_user_msg
      message = "Your report: '#{@report_title}' was #{@action}"
      #TODO: checks
      Notification.create(user: @user_id, admin_user: current_admin_user, message: message)
    end

    def set_user_msg
      report = Report.find(params[:id])
      @user_id = report.user.id
      @report_title = report.title
      @action = params[:commit] == "Update Report" ? "updated" : "deleted"
    end
  end

  index do
    selectable_column
    column("Title", nil, sortable: :title) {|report| link_to report.title, admin_report_path(report)}
    column ("Description") {|report| report.description.truncate(200, separator: ' ')}
    column ("User") {|report| report.user.name}
    column :created_at
    column :updated_at
    actions
  end

    show do |report|
    panel "Report Details" do
      attributes_table_for report  do
        row :title
        row :description
        row ("Autor") { |report| link_to report.user.name, admin_user_path(report.user) }
        row :category
        row :created_at
        row :updated_at
      end
    end
    active_admin_comments
  end


  filter :user, :as => :check_boxes, :label => 'Authors'
  filter :category, :as => :check_boxes
  filter :created_at
  config.sort_order = "created_at_desc"
  config.per_page = 10
  
end
