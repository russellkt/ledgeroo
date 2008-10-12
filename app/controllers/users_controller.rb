class UsersController < ApplicationController
  #permit "admin", :except => [:new, :create, :activate]

  before_filter :load_user,  :only => [:edit, :update, :suspend, :unsuspend, :destroy, :purge]
  before_filter :load_users, :only => [:index]

  protected
  def load_users
    @users = User.find(:all)
  end

  def load_user
    @user = User.find(params[:id])
  end

  public
  def index
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      User::ROLES.each do |role|
        if params[:roles].include?(role)
          @user.has_role(role)
        else
          @user.has_no_role(role)
        end
      end
      flash[:notice] = "User was updated."
      redirect_to users_path
    else
      flash.now[:error] = "There was a problem updating the user."
      render :action => 'edit'
    end
  end

  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.register! if @user.valid?
    @user.activate! # Go ahead and immediately accept new users, no auth required.
    if @user.errors.empty?
      self.current_user = @user
      redirect_to edit_user_url(@user)
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end

  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate!
      flash[:notice] = "Signup complete!"
    end
    redirect_back_or_default('/')
  end

  def suspend
    @user.suspend! 
    redirect_to users_path
  end

  def unsuspend
    @user.unsuspend! 
    redirect_to users_path
  end

  def destroy
    @user.delete!
    redirect_to users_path
  end

  def purge
    @user.destroy
    redirect_to users_path
  end
end
