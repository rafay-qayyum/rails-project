class Reply < ApplicationRecord
  belongs_to :post
  belongs_to :replier, polymorphic: true
  validates :content, presence: true, length: {minimum:5, maximum:200 }
  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "id", "post_id", "replier_id", "replier_type", "updated_at"]
  end

end
