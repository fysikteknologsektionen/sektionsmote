class ItemPositionToString < ActiveRecord::Migration[5.2]
  def up
    change_column :items, :position, :string
  end
  def down
    change_column :items, :position, :integer
  end
end
