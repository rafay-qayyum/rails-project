class Enrollment < ApplicationRecord

  # Associations
  belongs_to :student
  belongs_to :course

  # Validations
  validates :student_id, presence: true, numericality: { only_integer: true }
  validates :course_id, presence: true, numericality: { only_integer: true }
  validates :chapters_completed, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }#, default: 0
  validates :grade, presence: true, inclusion: { in: %w(A+ A B+ B C+ C D+ D F) }#, default: "F"

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    ["chapters_completed", "course_id", "created_at", "grade", "id", "student_id", "updated_at"]
  end

end
