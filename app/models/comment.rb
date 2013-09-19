class Comment < ActiveRecord::Base
  attr_accessible :body, :link_id, :parent_id, :user_id

  belongs_to :link
  belongs_to :user
  belongs_to :parent_comment, class_name: "Comment", foreign_key: :parent_id, primary_key: :id
  has_many :children_comments, class_name: "Comment", foreign_key: :parent_id, primary_key: :id
end