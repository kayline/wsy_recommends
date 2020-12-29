class CreatePeopleAndEpisodes < ActiveRecord::Migration[6.1]
  def change
    create_table :people do |t|
      t.text :first_name, null: false
      t.text :last_name, null: false
      t.text :bio_link
      t.text :twitter_handle
      t.boolean :guest, null: false

      t.timestamps
    end

    create_table :episodes do |t|
      t.datetime :release_date
      t.integer :number
      t.text :title, null: false

      t.timestamps
    end

    add_reference :recommendations, :episode
    add_reference :recommendations, :person
  end
end
