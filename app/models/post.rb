class Post < ApplicationRecord
  belongs_to :course
  belongs_to :poster, polymorphic: true
  validates :content, presence: true, length: {minimum:5, maximum:200 }
  def self.ransackable_attributes(auth_object = nil)
    ["content", "course_id", "created_at", "id", "poster_id", "poster_type", "updated_at"]
  end
end
