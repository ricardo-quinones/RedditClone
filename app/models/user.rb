require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessible :email, :password
  attr_reader :password

  before_save :ensure_token

  validates :email, uniqueness: true
  validates :email, :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }

  has_many :links
  has_many(
    :subs,
    class_name: "Sub",
    foreign_key: :moderator_id,
    primary_key: :id
  )

  has_many :comments

  def self.find_by_credentials(email, password)
    user = User.find_by_email(email)
    (user.nil? || !user.is_password?(password) ? nil : user)
  end

  def self.generate_token
    SecureRandom.urlsafe_base64(16)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password).to_s
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def reset_token!
    self.token = User.generate_token
    self.save!
  end

  private

  def ensure_token
    self.token ||= User.generate_token
  end
end
