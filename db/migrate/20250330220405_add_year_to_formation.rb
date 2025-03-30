class AddYearToFormation < ActiveRecord::Migration[7.2]
  def change
    add_column :formations, :year, :integer
  end
end
