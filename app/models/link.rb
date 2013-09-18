class Link < ActiveRecord::Base
  attr_accessible :body, :title, :url, :user_id

  validates :title, :url, :user_id, presence: true
  validates :url, format: URI::regexp(%w(http https))

  belongs_to :user

  has_many :sub_links
  has_many :subs, through: :sub_links, source: :sub
end
