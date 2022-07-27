class UsersController < ApplicationController
  before_action :set_user, only: %i[ show auth is_authorized edit update ]
  before_action :redirect_if_unauthed, only: %i[ edit update ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  def auth
    @user.password = ''
  end

  def is_authorized
    if @user.password == user_params[:password]
      cookies[:password] = @user.password
      redirect_to edit_user_url(@user)
      return
    end
    render :auth, error: true
  end

  # GET /users/1 or /users/1.json
  def show
    if !is_authorized?
      redirect_to auth_user_url(@user)
      return
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @svg = user_svg(@user)
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :password, :title, :bio, :avatar)
    end

    def redirect_if_unauthed
      redirect_to user_url(@user) if !is_authorized?
    end

    def is_authorized?
      cookies[:password] == @user.password
    end

    def edit_url
      if is_authorized?
        edit_user_path(@user)
      else
        auth_user_path(@user)
      end
    end
    helper_method :edit_url

    def user_svg(user)
      @qrcode = RQRCode::QRCode.new("https://fiat.lol/users/#{user.id}")
      @qrcode.as_svg(
        offset: 0,
        color: '000',
        shape_rendering: 'crispEdges',
        module_size: 6
      )
    end
    helper_method :user_svg
  end
