ActiveAdmin.register Comment do
  belongs_to :report
  actions :all, :except => [:edit, :new, :show, :create, :update]

  index do
    selectable_column
    id_column
    column :text
    column ("Author") {|comment| link_to comment.user.name, admin_user_path(comment.user)}
    column :created_at
    column :updated_at
    actions
  end

  filter :user, :as => :check_boxes, :label => 'Authors'
  filter :created_at
  filter :text
  config.sort_order = "created_at_desc"
  config.per_page = 10
end
