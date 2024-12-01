class ChangeFieldsAtVolunteer < ActiveRecord::Migration[7.2]
  def change
    rename_column :volunteers, :name, :full_name
    add_column :volunteers, :address, :string
    add_column :volunteers, :coordination_notes, :string
    add_column :volunteers, :email, :string
    remove_column :volunteers, :cpf, :integer

    add_reference :volunteers, :current_team, foreign_key: { to_table: :teams }, type: :uuid, index: true
    add_reference :volunteers, :original_team, foreign_key: { to_table: :teams }, type: :uuid, index: true
  end
end
