module Api
  module V1 
    class SessionsController < ApplicationController
      
      skip_before_action :authenticate_user, only: [:create]

      # POST api/v1/login
      def create
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          user.generate_auth_token 
          render json:{
            message: "User authenticated successfully!",
            auth_token: user&.auth_token,
          }, status: :ok and return
        else
          render json:{
            message: "Invalid username or password",
          }, status: :unauthorized and return
        end
      end
    
      # DELETE api/v1/logout
      def destroy
        user = User.find_by(auth_token: request.headers['Authorization']&.match(/^Bearer\s+(.*)$/)&.captures&.first)
        if user
          user.invalidate_auth_token
          render json:{
            message: "User logged out successfully!",
          }, status: :ok and return
        else
          render json:{
            message: "Invalid authentication token!",
          }, status: :unauthorized and return
        end
      end
    end
  end 
end
