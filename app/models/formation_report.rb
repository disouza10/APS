class FormationReport < ApplicationRecord
  acts_as_paranoid
  audited

  has_many :formations, dependent: :destroy

  scope :from_year, ->(year) { where('EXTRACT(YEAR FROM formation_reports.date) = ?', year) }

  def self.report_by_year(year)
    formation_reports = from_year(year)
    total_formations = formation_reports.count

    report_by_formation_reports(formation_reports, total_formations)
  end

  def self.volunteer_presence_last_formations(limit)
    formation_reports = FormationReport.order(created_at: :desc).limit(limit)
    total_formations = formation_reports.size

    report_by_formation_reports(formation_reports, total_formations)
  end

  private_class_method def self.report_by_formation_reports(formation_reports, total_formations)
    ids_sql = formation_reports.ids.map { |id| "'#{id}'" }.join(',')
    return [] if ids_sql.empty?

    volunteer_count_sql = <<-SQL.squish
      COUNT(formations.id) FILTER (WHERE (volunteers.status = 'active' OR volunteers.status IS NULL))
    SQL

    volunteer_status_sql = <<-SQL.squish
      CASE
        WHEN #{volunteer_count_sql} = 0 THEN 'critical'
        WHEN #{volunteer_count_sql} < (#{total_formations}/2.0) THEN 'attention'
        ELSE 'ok'
      END
    SQL

    Volunteer.joins(:current_team)
      .joins("LEFT JOIN formations ON formations.volunteer_id = volunteers.id AND formations.formation_report_id IN (#{ids_sql}) AND formations.team_id = teams.id")
      .where(volunteers: { deleted_at: nil }, teams: { deleted_at: nil })
      .select(
        'teams.name AS team_name',
        'volunteers.full_name',
        'volunteers.email',
        "#{volunteer_count_sql} AS presence_count",
        "#{total_formations} AS total_formations",
        "#{volunteer_status_sql} AS volunteer_status"
      )
      .group('teams.name, volunteers.full_name, volunteers.email')
      .order('teams.name, volunteers.full_name')
  end
end
