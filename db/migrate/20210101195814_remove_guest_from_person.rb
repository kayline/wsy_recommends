class RemoveGuestFromPerson < ActiveRecord::Migration[6.1]
  def change
    remove_column :people, :guest
  end
end
