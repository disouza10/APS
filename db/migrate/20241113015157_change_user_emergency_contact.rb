class ChangeUserEmergencyContact < ActiveRecord::Migration[7.2]
  def change
    rename_column :users, :emergency_contact, :emergency_contact_phone
    add_column :users, :emergency_contact_name, :text
  end
end
