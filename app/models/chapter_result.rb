class ChapterResult < ApplicationRecord

  # Associations
  belongs_to :chapter
  belongs_to :student
  belongs_to :course
  has_many :peer_reviews, dependent: :destroy

  has_one_attached :attempted_assignment
  has_one_attached :attempted_quiz

  # Validations
  validates :chapter_id, presence: true, numericality: { only_integer: true }
  validates :student_id, presence: true, numericality: { only_integer: true }

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    ["chapter_id", "course_id", "created_at", "id", "student_id", "updated_at"]
  end
end
