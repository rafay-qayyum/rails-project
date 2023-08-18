class Instructor < ApplicationRecord
  before_action: authenticate_Instructor!
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many  :courses, dependent: :destroy
  has_many  :posts, as: :poster, dependent: :destroy
  has_many  :replies, as: :replier, dependent: :destroy

  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :is_suspended, inclusion: { in: [true, false] }
  validates :email, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "id", "is_suspended", "name", "remember_created_at", "reset_password_sent_at", "reset_password_token", "updated_at"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["courses", "posts", "replies"]
  end
end
