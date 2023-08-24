class Course < ApplicationRecord

  # Callbacks
  before_validation do
    if self.new_record?
      self.total_chapters = 0
    end
  end

  # Associations
  belongs_to :instructor
  has_one_attached :image
  has_many :posts, dependent: :destroy
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments
  has_many :chapters, dependent: :destroy
  has_many :chapter_results, through: :chapters

  # Validations
  validates :total_chapters, presence: true, numericality: { only_integer: true , greater_than_or_equal_to: 0 } #, default: 0
  validates :title, presence: true, length: { minimum: 5 , maximum: 60 }
  validates :description, presence: true, length: { minimum: 5, maximum: 500 }
  validates :price, presence: true
  validates :language, presence: true
  validates :requirements, presence: true, length: { minimum:0, maximum:400 }
  validates :instructor_id, presence: true, numericality: { only_integer: true }

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "instructor_id", "language", "price", "requirements", "title", "total_chapters", "updated_at"]
  end
end

