class AddHostStatusColumnsToPerson < ActiveRecord::Migration[6.1]
  def change
    add_column(:people, :is_current_host, :boolean, default: false)
    add_column(:people, :is_former_host, :boolean, default: false)
  end
end
