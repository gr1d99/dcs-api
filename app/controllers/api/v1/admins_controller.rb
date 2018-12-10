# frozen_string_literal: true

module Api
  module V1
    class AdminsController < ApplicationController
      before_action :authenticate_user!, :admin_only!

      def add_user
        result = Admins::CreateUserService.call(user_params)
        if result.success?
          render json: result.model, status: :created
        else
          render json: result.model.errors, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.permit(:email)
      end

      def admin_only!
        forbidden_access unless current_user.is_admin
      end

      def forbidden_access
        responder('error',
                  :forbidden,
                  error: 'You do not have enough permission to make such request ')
      end
    end

  end
end
