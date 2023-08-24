class Chapter < ApplicationRecord

  # Callbacks
  after_create :update_total_chapters

  # Associations
  belongs_to :course
  has_one_attached :quiz
  has_one_attached :assignment
  has_one :chapter_results, dependent: :destroy, :class_name => "ChapterResult"

  # Validations
  validates :name, presence: true, length: { minimum:10, maximum: 50 }
  validates :content, presence: true, length: { minimum:40, maximum:800 }
  validates :course_id, presence: true, numericality: { only_integer: true }

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    ["content", "course_id", "id", "name", "quiz", "assignment"]
  end

private
  def update_total_chapters
    self.course.total_chapters = self.course.chapters.count
    self.course.save
  end
end
