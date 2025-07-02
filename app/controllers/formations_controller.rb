class FormationsController < ApplicationController
  before_action :set_params
  before_action :set_report

  def index
  end

  def critical_volunteers
    @grouped_report = @report.map do |report|
      next if report.volunteer_status != 'critical'
      { team_name: report.team_name, full_name: report.full_name, email: report.email }
    end.compact.group_by { |report| report[:team_name] }
    @title = 'Voluntários Críticos (não participaram de nenhuma formação)'
  end

  private

  def set_params
    @year = params[:year]
    @last_formations = params[:last_formations].to_i if params[:last_formations].present?
  end

  def set_report
    return report_by_year if @year.present?
    return report_by_last_formations if @last_formations.present?

    @report = []
    @title = 'Selecione um filtro para visualizar as formações'
  end

  def report_by_year
    @report = FormationReport.report_by_year(@year)
    @title = "Detalhes das formações do ano de #{@year}"
  end

  def report_by_last_formations
    @report = FormationReport.volunteer_presence_last_formations(@last_formations)
    @title = "Detalhes das últimas #{@last_formations} formações"
  end
end
