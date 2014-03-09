ActiveAdmin.register User do
  permit_params :email, :name, :admin, :password, :password_confirmation
  menu priority: 3
  menu :label => "Authors"
  menu :parent => "Users"

end
