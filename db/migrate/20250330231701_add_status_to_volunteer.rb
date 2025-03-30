class AddStatusToVolunteer < ActiveRecord::Migration[7.2]
  def change
    add_column :volunteers, :status, :string, default: 'active'
  end
end
