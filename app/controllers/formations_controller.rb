class FormationsController < ApplicationController
  def index
  end

  def show
  end

  def show_by_year
    @formations = Formation.from_year(params[:year])
    @formation_name = @formations.first.name

    render :show
  end
end
