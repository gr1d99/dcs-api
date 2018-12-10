# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      before_action :authenticate_user!, only: :destroy

      def create
        unless user_authenticated?
          reject_login!
          return
        end

        render json: { jwt_token: jwt_token }, status: :ok
      rescue ActiveRecord::RecordNotFound
        reject_login!
      end

      def destroy
        blacklist_auth_token
        render json: { message: 'you have been logged out' }, status: :ok
      end

      private

      def blacklist_auth_token
        if Blacklist.jti_exists?(raw_jti)
          render json: { error: 'token has been revoked' }, status: :unauthorized
          return
        end
        jwt = auth_token.split.last
        Users::BlacklistJwtService.call(jwt: jwt)
      end

      def login_params
        params.permit(:email, :password).to_h
      end

      def jwt_token
        DcsJwt.encode(payload: { email: login_params[:email] })
      end

      def user
        User.find_by!(email: login_params[:email])
      end

      def user_authenticated?
        user.authenticate(login_params[:password])
      end

      def reject_login!
        render json: { error: 'Incorrect email or password' }, status: :unauthorized
      end
    end
  end
end
