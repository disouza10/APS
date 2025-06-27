class FormationReport < ApplicationRecord
  acts_as_paranoid
  audited

  has_many :formations, dependent: :destroy

  scope :from_year, ->(year) { where('EXTRACT(YEAR FROM formation_reports.date) = ?', year) }

  def self.report_by_year(year)
    formation_reports = self.from_year(year)
    total_formations = formation_reports.count

    report_by_formation_reports(formation_reports, total_formations)
  end

  def self.volunteer_presence_last_formations(limit)
    formation_reports = FormationReport.order(created_at: :desc).limit(limit)
    total_formations = formation_reports.size

    report_by_formation_reports(formation_reports, total_formations)
  end

  private_class_method def self.report_by_formation_reports(formation_reports, total_formations)
    formation_report_ids = formation_reports.ids
    cross_join_sql = if formation_report_ids.any?
      "CROSS JOIN unnest(ARRAY[#{formation_report_ids.map { |id| "'#{id}'" }.join(',')}]) AS last_formation_reports(id)"
    else
      ''
    end

    Volunteer.active
      .joins(:current_team)
      .joins(cross_join_sql)
      .joins(<<-SQL.squish)
        LEFT JOIN formations
          ON formations.formation_report_id = last_formation_reports.id::uuid
          AND formations.volunteer_id = volunteers.id
          AND formations.team_id = teams.id
      SQL
      .where(teams: { status: 'active' })
      .group('teams.name, volunteers.full_name, volunteers.email')
      .select(
        'teams.name AS team_name',
        'volunteers.full_name',
        'volunteers.email',
        'COUNT(formations.id) AS presence_count',
        "#{total_formations} AS total_formations"
      )
      .order('teams.name, volunteers.full_name')
  end
end
