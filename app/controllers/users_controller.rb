class UsersController < ApplicationController
  before_filter :authenticate_user!, :ensure_admin
  before_action :set_user, only: [:show, :edit, :update, :destroy, :reinvite]

  def index
    @users = params[:all_customers] ? User.all_customers : User.customers
  end

  def show
  end

  def new
    @user = User.new(:active => true)
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        User.invite!({:email => @user.email}, current_user)
        #@user.invite!(current_user)
        format.html { redirect_to @user, notice: 'User was successfully invited.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        logger.debug @user.errors.inspect
        format.html { render action: 'new', alert:  @user.errors.inspect }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        logger.debug @user.errors.inspect
        format.html { render action: 'edit', alert:  @user.errors.inspect }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.delete # only sets the active flag
    redirect_to users_path, notice: 'Customer was successfully deactivated.'
  end
  
  def reactivate
    @user.undelete
    redirect_to users_path, notice: 'Customer was successfully reactivated.'
  end
  
  def reinvite
    @user.invite!
    flash[:notice] = @user.first_name + " " + @user.last_name + " has been re-invited."
    redirect_to users_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :address1, :address2, :city, :state, :role,
        :registration_number, :control_number, :expires_on, :active, :terms)
    end

end
