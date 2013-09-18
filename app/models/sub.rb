class Sub < ActiveRecord::Base
  attr_accessible :moderator_id, :name

  validates :name, :moderator_id, presence: true
  validates :name, uniqueness: {scope: :moderator_id,
    message: "You already created this Sub."}

  has_many :sub_links
  has_many :links, through: :sub_links, source: :link

  belongs_to(
    :moderator,
    class_name: "User",
    foreign_key: :moderator_id,
    primary_key: :id
  )

end
