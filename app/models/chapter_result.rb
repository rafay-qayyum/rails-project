class ChapterResult < ApplicationRecord

  # Associations
  belongs_to :chapter
  belongs_to :student
  has_one_attached :attempted_assignment
  has_one_attached :attempted_quiz

  # Validations
  validates :quiz_marks, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :assignment_marks, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to:100 }
  validates :chapter_id, presence: true, numericality: { only_integer: true }
  validates :student_id, presence: true, numericality: { only_integer: true }

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    ["assignment_marks", "chapter_id", "course_id", "created_at", "id", "quiz_marks", "student_id", "updated_at"]
  end
end
