ActiveAdmin.register Report do
menu priority: 4
permit_params :title, :description, :user_id, :category_id, :editor_id, :editor_type, {permissions_attributes: [:author_can_edit, :author_can_delete, :editor_can_edit, :editor_can_delete]}


  action_item :only => :show do
    link_to('View comments', admin_report_comments_path(report))
  end

controller do
    def user_reports
      @reports = Report.where(user_id: params[:user_id]).page(params[:page]).per(10)
      render action: 'index', :layout => false
    end
  end

  controller do
    before_action :add_editor_info, only: :update
    before_action :save_destroyer_info, only: :destroy

    def add_editor_info
      request.params["report"].merge!({editor_id: current_admin_user.id, editor_type: "AdminUser"})
    end

    def save_destroyer_info
      Report.find(request.params[:id]).update(editor: nil, destroyer: current_admin_user)
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
    panel "Permissions" do
      attributes_table_for report.permissions  do
        row ("Author can edit report"){ |permissions| permissions.author_can_edit? ? "YES" : "NO" }
        row ("Author can delete report"){ |permissions| permissions.author_can_delete? ? "YES" : "NO" }
        row ("Editor can edit report"){ |permissions| permissions.editor_can_edit? ? "YES" : "NO" }
        row ("Editor can delete report"){ |permissions| permissions.editor_can_delete? ? "YES" : "NO" }
      end
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Details" do
      f.input :user
      f.input :category
      f.input :title
      f.input :description
    end
    f.inputs "Meta Data", :for => [:permissions, f.object.permissions || Permissions.new] do |pf|
      pf.input :author_can_edit
      pf.input :author_can_delete
      pf.input :editor_can_edit
      pf.input :editor_can_delete
    end
    f.actions
  end


  filter :user, :as => :check_boxes, :label => 'Authors'
  filter :category, :as => :check_boxes
  filter :created_at
  config.sort_order = "created_at_desc"
  config.per_page = 10
  
end
