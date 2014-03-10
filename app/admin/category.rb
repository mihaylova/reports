ActiveAdmin.register Category do
menu priority: 5
  
   index do
    selectable_column

    column("Name", nil, sortable: :name) {|category| link_to category.name, admin_category_path(category)}
    column :created_at
    column :updated_at
    actions
  end

  filter :name
  filter :created_at
  config.per_page = 10
  
end
