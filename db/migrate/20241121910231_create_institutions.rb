class CreateInstitutions < ActiveRecord::Migration[7.2]
  def change
    create_table :institutions, id: :uuid do |t|
      t.string :name
      t.text :description
      t.string :phone
      t.string :email

      t.datetime :deleted_at
      t.timestamps

      t.index([ :id, :deleted_at ], unique: true)
    end
  end
end
