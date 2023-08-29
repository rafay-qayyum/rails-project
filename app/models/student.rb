class Student < ApplicationRecord

  # Callbacks
  before_validation :set_defaults, on: :create

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  # Associations
  has_many :posts, as: :poster, dependent: :destroy
  has_many :replies, as: :replier, dependent: :destroy
  has_many :enrollments, dependent: :destroy
  has_many :courses, through: :enrollments, dependent: :destroy
  has_many :chapter_results, dependent: :destroy
  has_one_attached :image

  # Validations
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :is_suspended, inclusion: { in: [true, false] }
  validates :email, presence: true, uniqueness: true
  validates :encrypted_password, presence: true

  # Ransack: Active Admin
  def self.ransackable_attributes(auth_object=nil)
    ["email", "is_suspended", "name", "updated_at", "created_at", "remember_created_at", "reset_password_sent_at", "reset_password_token", "encrypted_password"]
  end

  # Ransack: Active Admin
  def self.ransackable_associations(auth_object = nil)
    ["chapter_results", "courses", "enrollments", "posts", "replies"]
  end

  # Check if the requested role is student: Devise
  def is?( requested_role )
    :student.to_s == requested_role.to_s
  end
private
  # set default values
  def set_defaults
    self.is_suspended = false
    self.name = self.email.split("@")[0]
  end
end
