class CreateFormations < ActiveRecord::Migration[7.2]
  def change
    create_table :formations, id: :uuid do |t|
      t.datetime :answered_at
      t.string :email
      t.string :name
      t.string :team
      t.string :feedback

      t.timestamps
      t.datetime :deleted_at

      t.references :team, foreign_key: { to_table: :teams }, type: :uuid, index: true

      t.index([ :id, :deleted_at ], unique: true)
    end
  end
end
