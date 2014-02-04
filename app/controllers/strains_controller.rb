class StrainsController < ApplicationController
  before_action :set_strain, only: [:show, :edit, :update, :destroy]

  # GET /strains
  def index
    @strains = Strain.all
  end

  # GET /strains/1
  def show
  end

  # GET /strains/new
  def new
    @strain = Strain.new
  end

  # GET /strains/1/edit
  def edit
  end

  # POST /strains
  def create
    @strain = Strain.new(strain_params)

    if @strain.save
      redirect_to @strain, notice: 'Strain was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /strains/1
  def update
    if @strain.update(strain_params)
      redirect_to @strain, notice: 'Strain was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /strains/1
  def destroy
    @strain.destroy
    redirect_to strains_url, notice: 'Strain was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_strain
      @strain = Strain.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def strain_params
      params.require(:strain).permit(:name)
    end
end
