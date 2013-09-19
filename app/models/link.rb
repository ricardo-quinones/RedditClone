class Link < ActiveRecord::Base
  attr_accessible :body, :title, :url, :user_id

  validates :title, :url, :user_id, presence: true
  validates :url, format: URI::regexp(%w(http https))

  belongs_to :user

  has_many :sub_links
  has_many :subs, through: :sub_links, source: :sub
  has_many :comments

  def comments_by_parent_id
    comments = Comment.where(link_id: self.id)

    {}.tap do |hash|
      hash[nil] = comments.select { |comment| comment.parent_id == nil }

      comments.each do |comment|
        array = comments.select { |child_comment| child_comment.parent_id == comment.id }
        hash[comment.id] = array unless array.empty?
      end
    end
  end
end