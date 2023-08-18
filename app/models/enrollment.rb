class Enrollment < ApplicationRecord
  belongs_to :student
  belongs_to :course

  validates :chapters_completed, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }#, default: 0
  validates :grade, presence: true, inclusion: { in: %w(A+ A B+ B C+ C D+ D F) }#, default: "F"

  def self.ransackable_attributes(auth_object = nil)
    ["chapters_completed", "course_id", "created_at", "grade", "id", "student_id", "updated_at"]
  end

end
