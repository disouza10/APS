class ChangeFormation < ActiveRecord::Migration[7.2]
  def change
    add_reference :formations, :volunteer, foreign_key: { to_table: :volunteers }, type: :uuid, index: true
    add_reference :formations, :formation_report, foreign_key: { to_table: :formation_reports }, type: :uuid, index: true

    remove_column :formations, :name, :string
    remove_column :formations, :volunteer_name, :string
    remove_column :formations, :volunteer_email, :string
    remove_column :formations, :year, :integer
  end
end
