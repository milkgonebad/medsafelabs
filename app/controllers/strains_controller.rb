class StrainsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_strain, only: [:show, :edit, :update, :destroy]

  def index
    @strains = Strain.all
  end

  def show
  end

  def new
    @strain = Strain.new
  end

  def edit
  end

  def create
    @strain = Strain.new(strain_params)
    if @strain.save
      redirect_to @strain, notice: 'Strain was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @strain.update(strain_params)
      redirect_to @strain, notice: 'Strain was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    if @strain.destroy
      redirect_to strains_url, notice: 'Strain was successfully destroyed.'
    else
      redirect_to strains_url, alert: @strain.errors.full_messages.join(" ")
    end
  end

  private
    def set_strain
      @strain = Strain.find(params[:id])
    end

    def strain_params
      params.require(:strain).permit(:name)
    end
end
