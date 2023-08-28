class PeerReview < ApplicationRecord

  # Associations
  belongs_to :reviewee, :class_name => "Student"
  belongs_to :reviewer, :class_name => "Student"
  belongs_to :chapter_result

  # Validations
  validates :quiz_marks, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :assignment_marks, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to:100 }
  validates :chapter_result_id, presence: true, numericality: { only_integer: true }

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    ["chapter_result_id", "created_at", "id", "review", "student_id", "updated_at"]
  end
end
