class PreventNullValues < ActiveRecord::Migration[6.1]
  def change
    change_column_null :episodes, :number, false
  end
end
