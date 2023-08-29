module Searchable
  extend ActiveSupport::Concern
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    settings index: { number_of_shards: 1 } do
      mappings do
        indexes :id, type: :integer
        indexes :title , type: :text
        indexes :price, type: :float
        indexes :language, type: :text
        indexes :total_chapters, type: :integer
        indexes :instructor_id, type: :integer
        indexes :created_at, type: :date
        indexes :updated_at, type: :date
      indexes :image, type: :binary
      end
    end
    def self.search(query)
      __elasticsearch__.search(
        {
          query: {
            multi_match: {
              query: query,
              fields: ['title^10', 'description^5', 'language^5', 'requirements^5']
            }
          }
        }
      )
  end

end
