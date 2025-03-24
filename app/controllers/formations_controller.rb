class FormationsController < ApplicationController
  def index
  end

  def show_by_year
    @formation = Formation.from_year(params[:year])
  end
end
