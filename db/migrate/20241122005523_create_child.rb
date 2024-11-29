class CreateChild < ActiveRecord::Migration[7.2]
  def change
    create_table :children, id: :uuid do |t|
      t.string :name
      t.date :birth_date
      t.integer :cpf
      t.text :notes

      t.datetime :deleted_at
      t.timestamps

      t.references :team, foreign_key: { to_table: :teams }, type: :uuid, index: true
      t.references :institution, foreign_key: { to_table: :institutions }, type: :uuid, index: true

      t.index([ :id, :deleted_at ], unique: true)
    end
  end
end
