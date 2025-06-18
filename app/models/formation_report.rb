class FormationReport < ApplicationRecord
  acts_as_paranoid

  has_many :formations, dependent: :destroy

  scope :from_year, ->(year) { where('EXTRACT(YEAR FROM formation_reports.date) = ?', year) }

  def self.report_by_year(year)
    Volunteer
      .select('teams.name AS team_name, volunteers.full_name, volunteers.email, COUNT(formations.id) AS presence_count')
      .joins('INNER JOIN teams ON volunteers.current_team_id = teams.id AND teams.deleted_at IS NULL')
      .joins('LEFT JOIN formations ON formations.volunteer_id = volunteers.id AND formations.deleted_at IS NULL')
      .joins("LEFT JOIN formation_reports ON formation_reports.id = formations.formation_report_id AND EXTRACT(YEAR FROM formation_reports.date) = #{year} AND formation_reports.deleted_at IS NULL")
      .where("volunteers.status = 'active' AND volunteers.deleted_at IS NULL")
      .group('teams.name, volunteers.email, volunteers.full_name')
      .order('teams.name, volunteers.full_name')
  end
end
