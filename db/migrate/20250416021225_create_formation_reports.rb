class CreateFormationReports < ActiveRecord::Migration[7.2]
  def change
    create_table :formation_reports do |t|
      t.string :name
      t.integer :year
      t.jsonb :attendees, default: []
      t.jsonb :missing, default: []

      t.datetime :deleted_at
      t.timestamps

      t.index([:id, :deleted_at], unique: true)
    end
  end
end
