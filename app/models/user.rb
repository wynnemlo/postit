class User < ActiveRecord::Base
  include Sluggable
  sluggable_column :username

	has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
  validates :password, length: {minimum: 5},
    unless: Proc.new { |a| a.password.blank? }

  def admin?
    self.role == 'admin'
  end

  def moderator?
    self.role == 'moderator'
  end

end