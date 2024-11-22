class AddTeams < ActiveRecord::Migration[7.2]
  def change
    Institution.all.each do |institution|
      Team.create!(name: institution.name, institution: institution, status: 'active')
    end
  end
end
