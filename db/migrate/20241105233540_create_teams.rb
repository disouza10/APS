class CreateTeams < ActiveRecord::Migration[7.2]
  def change
    create_table :teams, id: :uuid do |t|
      t.string :name
      t.string :description
      t.string :status, default: 'active'

      t.datetime :deleted_at
      t.timestamps

      t.index([ :id, :deleted_at ], unique: true)
    end
  end
end
