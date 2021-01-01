class CreateJoinTableEpisodePerson < ActiveRecord::Migration[6.1]
  def change
    create_join_table :episodes, :people do |t|
      t.index [:episode_id, :person_id]
      t.index [:person_id, :episode_id]
    end
  end
end
