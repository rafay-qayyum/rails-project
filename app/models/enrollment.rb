class Enrollment < ApplicationRecord
  # Callbacks
  before_validation :set_defaults, on: :create

  # Associations
  belongs_to :student
  belongs_to :course

  # Validations
  validates :chapters_completed, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }  #, default: 0
  validates :grade, presence: true, inclusion: { in: %w(A+ A B+ B C+ C D+ D F) }  #, default: "F"
  validates :course_id, presence: true, numericality: { only_integer: true }
  validates :student_id, presence: true, numericality: { only_integer: true }


  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    ["chapters_completed", "course_id", "created_at", "grade", "id", "student_id", "updated_at"]
  end
private
def set_defaults
  self.chapters_completed = 0
  self.grade = "F"
end
end
