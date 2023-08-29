class Course < ApplicationRecord

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  # import all records from the DB to Elasticsearch
  Course.import(force: true)

  # create the mapping in Elasticsearch
  settings index: { number_of_shards: 1 } do
    mappings dynamic: false do
      indexes :id, type: :integer
      indexes :title , type: :text
      indexes :price, type: :float
      indexes :language, type: :text
      indexes :total_chapters, type: :integer
      indexes :instructor_id, type: :integer
      indexes :created_at, type: :date
      indexes :updated_at, type: :date
    end
  end

  def self.search(query)
    __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query: query,
            fields: ['title^10', 'description^5', 'requirements^5']
          }
        }
      }
    )
  end
  # Callbacks
  before_validation do
    if self.new_record?
      self.total_chapters = 0
    end
  end

  # Associations
  belongs_to :instructor
  has_one_attached :image
  has_many :posts, dependent: :destroy
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments
  has_many :chapters, dependent: :destroy
  has_many :chapter_results, through: :chapters

  # Validations
  validates :total_chapters, presence: true, numericality: { only_integer: true , greater_than_or_equal_to: 0 } #, default: 0
  validates :title, presence: true, length: { minimum: 5 , maximum: 60 }
  validates :description, presence: true, length: { minimum: 5, maximum: 500 }
  validates :price, presence: true
  validates :language, presence: true
  validates :requirements, presence: true, length: { minimum:0, maximum:400 }
  validates :instructor_id, presence: true, numericality: { only_integer: true }

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "instructor_id", "language", "price", "requirements", "title", "total_chapters", "updated_at"]
  end


  # override as_indexed_json method to include image from ActiveStorage table
  def as_indexed_json(options={})
    self.as_json(
      only: [:id, :title, :price, :language, :total_chapters, :instructor_id, :created_at, :updated_at],
       methods: [:service_url]
    )
  end
  def service_url
    if self.image.attached?
      Rails.application.routes.url_helpers.rails_blob_url(self.image, only_path: true)
    else
      nil
    end
  end
end

