class ReportSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :can_edit, :can_destroy, :can_read, :created_at, :user
end
