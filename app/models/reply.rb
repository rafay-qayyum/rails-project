class Reply < ApplicationRecord

  # Associations
  belongs_to :post
  belongs_to :replier, polymorphic: true

  # Validations
  validates :content, presence: true, length: { minimum:5, maximum:200 }
  validates :replier_id, presence: true, numericality: { only_integer: true }
  validates :post_id, presence: true, numericality: { only_integer: true }

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "id", "post_id", "replier_id", "replier_type", "updated_at"]
  end
end
