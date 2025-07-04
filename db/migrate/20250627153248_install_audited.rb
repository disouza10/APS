# frozen_string_literal: true

class InstallAudited < ActiveRecord::Migration[7.2]
  def self.up
    create_table :audits, id: :uuid, default: -> { "gen_random_uuid()" }, force: true do |t|
      t.column :auditable_id, :uuid
      t.column :auditable_type, :string
      t.column :associated_id, :uuid
      t.column :associated_type, :string
      t.column :user_id, :uuid
      t.column :user_type, :string
      t.column :username, :string
      t.column :action, :string
      t.column :audited_changes, :jsonb
      t.column :version, :integer, default: 0
      t.column :comment, :string
      t.column :remote_address, :string
      t.column :request_uuid, :string
      t.column :created_at, :datetime
    end

    add_index :audits, [:auditable_type, :auditable_id, :version], name: 'auditable_index'
    add_index :audits, [:associated_type, :associated_id], name: 'associated_index'
    add_index :audits, [:user_id, :user_type], name: 'user_index'
    add_index :audits, :request_uuid
    add_index :audits, :created_at
  end

  def self.down
    drop_table :audits
  end
end
