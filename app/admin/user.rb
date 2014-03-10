ActiveAdmin.register User do
  permit_params :email, :name, :admin, :password, :password_confirmation
  menu priority: 3
  menu :label => "Authors"
  menu :parent => "Users"

  controller do
    before_action :check_for_pass, only: :update

    def check_for_pass
      #use request.params instead params
      params =  request.params["user"]
      if params[:password] == ""
        params.delete(:password)
        params.delete(:password_confirmation)
      end
    end
  end

  member_action :reports do
    @user = User.find(params[:id])
    @reports = @user.reports.page(params[:page]).per(10)
  end

  scope :all do |users|
    User.all
  end

  scope :editors do |users|
    User.where(role: "editor")
  end

  action_item :only => :show do
    link_to('View reports', reports_admin_user_path(user))

    #Some way.... :? :|
    #link_to('View reports', admin_reports_path + "?&q%5Buser_id_in%5D%5B%5D=#{user.id}")
  end

  action_item :only => :show do
    link_to('Add report', root_path)
  end
  
  index do
    selectable_column

    column("Name", nil, sortable: :name) {|user| link_to user.name, admin_user_path(user)}
    column :email
    column :admin
    column :created_at
    column :current_sign_in_at
    column :current_sign_in_ip
    column :sign_in_count
    actions
  end
  

  show do |user|
    panel "Account Details" do
      attributes_table_for user  do
        row :name
        row :email
        row :role
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
      end
      f.inputs "Change Password" do
        f.input :password
        f.input :password_confirmation
      end
      f.actions
    end


end