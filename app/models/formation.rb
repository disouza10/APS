class Formation < ApplicationRecord
  acts_as_paranoid

  belongs_to :team

  scope :from_year, ->(year) { where(year: year) }

  def self.report_by_year(year)
    Volunteer
      .select('teams.name AS team_name, volunteers.full_name AS volunteer_name, volunteers.email AS volunteer_email, COUNT(formations.volunteer_email) AS presence_count')
      .joins("LEFT JOIN formations ON formations.volunteer_email = volunteers.email AND formations.deleted_at IS NULL AND formations.year = #{year}")
      .joins('INNER JOIN teams ON volunteers.current_team_id = teams.id AND teams.deleted_at IS NULL')
      .where("volunteers.deleted_at IS NULL AND volunteers.status = 'active'")
      .group('teams.name, volunteers.email, volunteers.full_name')
      .order('teams.name, volunteer_name')
  end
end
