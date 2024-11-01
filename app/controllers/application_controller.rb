class ApplicationController < ActionController::API

  before_action :authenticate_user

  def authenticate_user
    token = request.headers['Authorization']&.match(/^Bearer\s+(.*)$/)&.captures&.first
    user = User.find_by(auth_token: token)

    if user && token_valid?(user)
      @current_user = user 
    else
      user.invalidate_auth_token if user 
      render json:{
        message:"Token expired. Please login again.",
        header: request.headers['Authorization']&.match(/^Bearer\s+(.*)$/)&.captures&.first,
      }, status: :unauthorized and return
    end

  end

  private

  def token_valid?(user)
    user.updated_at > 12.hours.ago
  end
end
