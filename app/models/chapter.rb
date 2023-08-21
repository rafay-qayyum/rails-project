class Chapter < ApplicationRecord
  belongs_to :course
  has_one_attached :quiz
  has_one_attached :assignment
  has_one :chapter_results, dependent: :destroy, :class_name => "ChapterResult"
  validates :name, presence: true, length: {minimum:10, maximum: 50}
  validates :content, presence: true, length: {minimum:40, maximum:800}

  def self.ransackable_attributes(auth_object = nil)
    ["content", "course_id", "id", "name", "quiz", "assignment"]
  end
end
