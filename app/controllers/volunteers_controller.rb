class VolunteersController < ApplicationController
  before_action :set_volunteer, only: %i[show edit destroy]

  def index
    @volunteers = Volunteer.all
  end

  def show
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_volunteer
    @volunteer = Volunteer.find(params["id"])
  end
end
