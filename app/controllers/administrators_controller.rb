class AdministratorsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_administrator, only: [:show, :edit, :update, :destroy]
  before_action :ensure_super_admin

  def index
    @administrators = params[:all] ? User.all_administrators : User.administrators
  end

  def show
  end

  def new
    @administrator = User.new(:active => true)
  end

  def edit
  end

  def create
    @administrator = User.new(administrator_params)
    @administrator.role = User::ROLES[:administrator]
    if @administrator.save
      @administrator.confirm!
      redirect_to administrators_path, notice: 'Administrator was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @administrator.update(administrator_params)
      redirect_to administrators_path, notice: 'Administrator was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @administrator.active = false
    if @administrator.save
      redirect_to administrators_url, notice: 'Administrator was successfully deactivated.'
    else
      redirect_to administrators_url, alert: 'Administrator was no successfully deactivated.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_administrator
      @administrator = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def administrator_params
      params.require(:user).permit(:first_name, :last_name, :role, :email, :password, :password_confirmation, :active)
    end
    
    def ensure_super_admin
      redirect_to dashboard_path unless current_user.super_admin?
    end
end
