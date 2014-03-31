class FaqController < ApplicationController
  before_filter :authenticate_user!, :ensure_admin
  
  def index
  end
  
end
