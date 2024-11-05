class CreateChildren < ActiveRecord::Migration[7.2]
  def change
    create_table :children do |t|
      t.string :name, null: false
      t.date :birth_date, null: false
      t.integer :cpf
      t.text :notes

      t.datetime :deleted_at
      t.timestamps

      t.index [ :id, :deleted_at ], unique: true
    end
  end
end
