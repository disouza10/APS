class CreateTeams < ActiveRecord::Migration[7.2]
  def change
    create_table :teams, id: :uuid do |t|
      t.string :name
      t.string :description
      t.string :status, default: 'active'

      t.references :institution, foreign_key: { to_table: :institutions }, type: :uuid, index: true
      t.references :volunteers, foreign_key: { to_table: :users }, type: :uuid, index: true
      t.references :children, foreign_key: { to_table: :child }, type: :uuid, index: true

      t.datetime :deleted_at
      t.timestamps

      t.index([ :id, :deleted_at ], unique: true)
    end
  end
end
