class UsersController < ApplicationController
  before_action :set_user, only: %i[ show auth is_authorized edit update print admin stats ]
  before_action :redirect_if_unauthed, only: %i[ edit update print admin stats ]
  before_action :require_admin, only: %i[ admin update ]

  # GET /users or /users.json
  def index
  end

  def print
    if @user.admin != true
      redirect_to root_url(@user)
      return
    end
    @users = User.all
    render(:layout => "layouts/print")
  end

  def admin
    @users = User.order(updated_at: :desc)
  end

  def stats
    # Getting errors with grouping and can't google the answers on the plane
    # fuck it, doing it the hacky way. Don't judge.
    connections = Relationship.group('user_id').count
    sorted_groups = connections.map { |k, v| [k, v] }
    sorted_groups = sorted_groups.sort { |x, y| x[1] <=> y[1] }.reverse.first(10)
    @connections = sorted_groups.map { |c| [User.find(c[0]), c[1]]}

  end

  def auth
    @user.password = ''
  end

  def is_authorized
    if @user.password == user_params[:password].strip && params[:event_code].strip == Rails.application.credentials.dig(:event_code)
      cookies[:password] = @user.password
      redirect_to edit_user_url(@user)
      return
    end
    render :auth, error: true
  end

  # GET /users/1 or /users/1.json
  def show
    #add a security check here
    if !cookies[:password]
      redirect_to auth_user_url(@user)
    end

    @me = User.find_by(password: cookies[:password])

    if !is_me? && params[:greeting] == @user.greeting && @user.name
      @relation = Relationship.find_or_create_by(user: @me, greeted: @user)
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
      @user = User.where("id = ?", params[:id].to_i).first
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :password, :title, :bio, :avatar)
    end

    def redirect_if_unauthed
      if @user
        redirect_to user_url(@user) if !is_me?
      else
        redirect_to root_url
      end
    end

    def require_admin
      redirect_to user_url(@user) unless is_me? and @user.admin == true
    end

    def is_me?
      cookies[:password] == @user.password
    end
    helper_method :is_me?

    def edit_url
      if is_me?
        edit_user_path(@user)
      else
        auth_user_path(@user)
      end
    end
    helper_method :edit_url

    def user_svg(user)
      @qrcode = RQRCode::QRCode.new("https://fiat.lol/users/#{user.id}?greeting=#{user.greeting}")
      @qrcode.as_svg(
        offset: 0,
        color: '000',
        shape_rendering: 'crispEdges',
        module_size: 5
      )
    end
    helper_method :user_svg
  end
