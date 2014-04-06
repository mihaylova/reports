class CommentSerializer < ActiveModel::Serializer
  attributes :id, :text, :user_id, :report_id, :can_edit, :can_destroy, :author_name, :updated, :created_at, :updated_at
end
