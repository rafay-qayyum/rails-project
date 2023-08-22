class Post < ApplicationRecord

  # Associations
  belongs_to :course
  belongs_to :poster, polymorphic: true

  # Validations
  validates :content, presence: true, length: { minimum:5, maximum:200 }
  validates :poster_id, presence: true, numericality: { only_integer: true }
  validates :course_id, presence: true, numericality: { only_integer: true }

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    ["content", "course_id", "created_at", "id", "poster_id", "poster_type", "updated_at"]
  end
end
