class AddInstitutionToTeams < ActiveRecord::Migration[7.2]
  def change
    add_reference :teams, :institution, foreign_key: true, type: :uuid, index: true
  end
end
