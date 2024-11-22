class CreateInstitutions < ActiveRecord::Migration[7.2]
  def change
    create_table :institutions, id: :uuid do |t|
      t.string :name
      t.text :description
      t.string :phone
      t.string :email

      t.references :responsibles, foreign_key: { to_table: :users }, type: :uuid, index: true
      t.references :child, foreign_key: { to_table: :child }, type: :uuid, index: true

      t.datetime :deleted_at
      t.timestamps

      t.index([ :id, :deleted_at ], unique: true)
    end
  end
end
