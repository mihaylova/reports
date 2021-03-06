ActiveAdmin.register User do
  permit_params :email, :name, :editor, :password, :password_confirmation, :last_editor_id, :has_password
  menu priority: 3
  menu :label => "Authors"
  menu :parent => "Users"

  

  controller do
    before_action :check_for_pass, only: :update
    before_action :update_has_pass, only: :update
    before_action :add_editor_info, only: :update

    def add_editor_info
      request.params["user"].merge!({last_editor_id: current_admin_user.id})
    end

    def update_has_pass
      request.params["user"].merge!({has_password: true}) if request.params["user"].has_key?(:password)
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


  action_item :only => :edit do
    link_to("Remove facebook account", remove_fb_account_admin_user_path(user)) if user.has_fb_account?
  end

  member_action :remove_fb_account do
    user = User.find(params[:id])
    if user.has_password?
      user.update(uid: nil, provider: nil)
      redirect_to admin_user_path(user)
    else
      redirect_to edit_admin_user_path(user), alert: "You can't remove facebook account on user who don't have active password"
    end
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
    column ("") {|user| user.has_fb_account? ? (link_to "facebook account", "https://www.facebook.com/#{user.uid}") : "Not Set"}
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
        row ("Facebook account") {|user| user.has_fb_account? ? (link_to "facebook account", "https://www.facebook.com/#{user.uid}") : "Not Set"}
        row ("Password"){|user| user.has_password? ? "YES" : "NO" }
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
      f.input :has_password
    end
    f.actions
  end

  filter :name
  filter :email
  filter :created_at
  config.sort_order = "created_at_desc"
  config.per_page = 10


end
