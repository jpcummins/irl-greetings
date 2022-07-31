class PublicController < ApplicationController
  def index
  end

  def logout
    cookies.delete :password
    redirect_to root_path
  end

end
