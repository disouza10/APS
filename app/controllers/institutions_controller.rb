class InstitutionsController < ApplicationController
  before_action :set_institution, only: %i[show edit destroy update]

  def index
    @institutions = Institution.all.page(params[:page])
  end

  def show
  end

  def new
    @institution = Institution.new
  end

  def create
    @institution = Institution.new(institution_params)

    if @institution.save
      redirect_to @institution, notice: flash_created(@institution)
    else
      render :new, error: flash_error
    end
  end

  def edit
  end

  def update
    if @institution.update(institution_params)
      redirect_to @institution, notice: flash_updated(@institution)
    else
      render :edit, error: flash_error
    end
  end

  def destroy
    if @institution.destroy
      redirect_to institutions_path, notice: flash_removed(@institution)
    else
      redirect_to institutions_path, error: flash_error
    end
  end

  private

  def set_institution
    @institution = Institution.find(params["id"])
  end

  def institution_params
    params.require(:institution).permit(
      :name,
      :email,
      :phone,
      :description
    )
  end
end
