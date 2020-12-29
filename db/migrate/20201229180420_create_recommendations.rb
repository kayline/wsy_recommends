class CreateRecommendations < ActiveRecord::Migration[6.1]
  def change
    create_table :recommendations do |t|
      t.text :name
      t.text :imdb_path
      t.timestamps
    end
  end
end
