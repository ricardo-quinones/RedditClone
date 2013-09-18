class SubLink < ActiveRecord::Base
  attr_accessible :sub_id, :link_id

  validates :sub_id, :link_id, presence: true
  validates :link_id, uniqueness: { scope: :sub_id,
    message: "That link has already been added to this Sub." }

  belongs_to :sub
  belongs_to :link
end
