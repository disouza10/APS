class FormationsController < ApplicationController
  def index
    @year = params[:year]
    @last_formations = params[:last_formations]

    return report_by_year if @year.present?
    return report_by_last_formations if @last_formations.present?

    @report = []
    @title = 'Selecione um filtro para visualizar as formações'
  end

  private

  def report_by_year
    @report = FormationReport.report_by_year(@year)
    @title = "Detalhes das formações do ano de #{@year}"
  end

  def report_by_last_formations
    @report = FormationReport.volunteer_presence_last_formations(@last_formations)
    @title = "Detalhes das últimas #{@last_formations} formações"
  end
end
