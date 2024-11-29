class CreateVolunteers < ActiveRecord::Migration[7.2]
  def change
    create_table :volunteers, id: :uuid do |t|
      t.string :name
      t.date :birth_date
      t.integer :cpf
      t.text :notes
      t.string :secondary_email
      t.string :phone
      t.string :occupation
      t.string :emergency_contact_phone
      t.string :emergency_contact_name

      t.datetime :deleted_at
      t.timestamps

      t.index([ :id, :deleted_at ], unique: true)
    end
  end
end
