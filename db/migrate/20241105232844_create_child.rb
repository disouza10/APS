class CreateChild < ActiveRecord::Migration[7.2]
  def change
    create_table :child, id: :uuid do |t|
      t.string :name
      t.date :birth_date
      t.integer :cpf
      t.text :notes

      t.datetime :deleted_at
      t.timestamps

      t.index([ :id, :deleted_at ], unique: true)
    end
  end
end
