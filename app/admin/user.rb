ActiveAdmin.register User do
  permit_params :email, :name, :editor, :password, :password_confirmation
  menu priority: 3
  menu :label => "Authors"
  menu :parent => "Users"

  

  controller do
    before_action :check_for_pass, only: :update
    after_action :send_user_msg, only: :update

    #TODO: Refactoring
    def send_user_msg
      user = User.find(params[:id])
      if user.updated?
        Notification.create(user: user, admin_user: current_admin_user, message: "Your profile was updated by admin")
      end
    end

    def check_for_pass
      #use request.params instead params
      params =  request.params["user"]
      if params[:password] == ""
        params.delete(:password)
        params.delete(:password_confirmation)
      end
    end
  end

  member_action :become do
    sign_in(:user, User.find(params[:id]))
    redirect_to root_path
  end

  # member_action :reports do
  #   @user = User.find(params[:id])
  #   @reports = @user.reports.page(params[:page]).per(10)
  #   #It will render views/admin/users/reports
  # end

  scope :all do |users|
    User.all
  end

  scope :editors do |users|
    User.where(editor: true)
  end

  action_item :only => :show do
    link_to('View reports', reports_admin_user_path(user))

    #Some way.... :? :|
    #link_to('View reports', admin_reports_path + "?&q%5Buser_id_in%5D%5B%5D=#{user.id}")
  end

  action_item :only => :show do
    link_to('Become', become_admin_user_path(user))
  end
  
  index do
    selectable_column

    column("Name", sortable: :name) {|user| link_to user.name, admin_user_path(user)}
    column :email
    column :editor
    column ("Reports") {|user| link_to user.reports_count, reports_admin_user_path(user)}
    # column ("Reports", sortable: :reports_count) {|user| link_to user.reports_count, reports_admin_user_path(user)}
    column :created_at
    column :updated_at
    column ("") {|user| link_to "become", become_admin_user_path(user)}
    actions
  end
  

  show do |user|
    panel "Account Details" do
      attributes_table_for user  do
        row :name
        row :email
        row ("Editor"){ |user| user.editor? ? "YES" : "NO" }
        row :created_at
        row :updated_at
      end
    end

    panel "Login Details" do
      attributes_table_for user  do
        row("current singed in at") {|user| user.current_sign_in_at || "Never signed in"}
        row("current singed in ip") {|user| user.current_sign_in_ip || "Never signed in"}
        row("last singed in at") {|user| user.last_sign_in_at || "Never signed in"}
        row("last singed in ip") {|user| user.last_sign_in_ip || "Never signed in"}
        row :sign_in_count
      end
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Details" do
      f.input :name
      f.input :email
      f.input :editor
    end
    f.inputs "Change Password" do
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  filter :name
  filter :email
  filter :created_at
  config.sort_order = "created_at_desc"
  config.per_page = 10


end
