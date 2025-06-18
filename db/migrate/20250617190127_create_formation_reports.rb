class CreateFormationReports < ActiveRecord::Migration[7.2]
  def change
    create_table :formation_reports, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.string :name
      t.date :date
      t.integer :active_volunteers_count
      t.integer :inactive_volunteers_count
      t.datetime :deleted_at
      t.timestamps

      t.index([:id, :deleted_at], unique: true)
    end
  end
end
