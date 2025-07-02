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

    volunteer_status = <<-SQL.squish
      CASE
        WHEN COUNT(valid_formations.id) FILTER (WHERE valid_formations.was_active) = 0 THEN 'critical'
        WHEN COUNT(valid_formations.id) FILTER (WHERE valid_formations.was_active) < (#{total_formations}/2.0) THEN 'attention'
        ELSE 'ok'
      END
    SQL

    sql = <<-SQL.squish
      WITH last_status_change AS (
        SELECT DISTINCT ON (auditable_id, formation_reports.date)
          audits.auditable_id AS volunteer_id,
          formation_reports.date,
          audits.audited_changes -> 'status' AS status_change,
          audits.created_at
        FROM formation_reports
        JOIN formations ON formations.formation_report_id = formation_reports.id
        JOIN audits ON audits.auditable_type = 'Volunteer'
                  AND audits.auditable_id = formations.volunteer_id
                  AND audits.created_at <= formation_reports.date
                  AND audits.audited_changes ? 'status'
        ORDER BY auditable_id, formation_reports.date, audits.created_at DESC
      ),
      valid_formations AS (
        SELECT formations.*, formation_reports.date,
          CASE
            WHEN last_status_change.volunteer_id IS NOT NULL THEN
              CASE
                WHEN (last_status_change.status_change->>1) = 'inactive' THEN false
                ELSE true
              END
            ELSE
              volunteers.status = 'active'
          END AS was_active
        FROM formations
        JOIN formation_reports ON formation_reports.id = formations.formation_report_id
        JOIN volunteers ON volunteers.id = formations.volunteer_id
        LEFT JOIN last_status_change ON last_status_change.volunteer_id = formations.volunteer_id
        AND last_status_change.date = formation_reports.date
        WHERE formation_reports.id IN (#{ids_sql})
      )
      SELECT
        teams.name AS team_name,
        volunteers.full_name,
        volunteers.email,
        COUNT(valid_formations.id) FILTER (WHERE valid_formations.was_active) AS presence_count,
        #{total_formations} AS total_formations,
        #{volunteer_status} AS volunteer_status
      FROM volunteers
      JOIN teams ON teams.id = volunteers.current_team_id AND teams.deleted_at IS NULL
      CROSS JOIN unnest(ARRAY[#{ids_sql}]) AS last_formation_reports(id)
      LEFT JOIN valid_formations ON valid_formations.formation_report_id = last_formation_reports.id::uuid
        AND valid_formations.volunteer_id = volunteers.id
        AND valid_formations.team_id = teams.id
      WHERE volunteers.deleted_at IS NULL
      GROUP BY teams.name, volunteers.full_name, volunteers.email
      ORDER BY teams.name, volunteers.full_name
    SQL

    Volunteer.find_by_sql(sql)
  end
end
