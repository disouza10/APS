class CreateInstitutions < ActiveRecord::Migration[7.2]
  def change
    create_table :institutions, id: :uuid do |t|
      t.string :name, null: false
      t.text :description
      t.string :phone
      t.string :email

      t.references :responsibles, null: false, foreign_key: { to_table: :users }, type: :uuid, index: true
      t.references :child, null: false, foreign_key: { to_table: :child }, type: :uuid, index: true

      t.datetime :deleted_at
      t.timestamps

      t.index([ :id, :deleted_at ], unique: true)
    end
  end
end
