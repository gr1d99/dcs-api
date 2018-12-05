module Api
  module V1
    class PasswordsController < ApplicationController
      before_action :set_password_params, only: %w[create]
      def new
        email = params.permit(:email)[:email]
        handle_email_not_provided and return unless email_provided?(email)
        @user = User.find_by_email(email)
        handle_email_provided
      end

      def create
        page_not_found and return unless @type == 'password_reset'
        page_not_found and return unless User.token_valid?(@type, @token)
        user = User.find_by_password_reset_token(@token)
        if @password == @confirm
          user.password = @password
          user.save!
          responder('success', :ok, message: 'Password successfully created')
        else
          responder('error', 422, error: 'Passwords do not match')
        end
      end

      private

      def password_params
        params.permit(:password, :confirm, :token, :type)
      end

      def set_password_params
        @token = password_params[:token]
        @type = password_params[:type]
        @password = password_params[:password]
        @confirm = password_params[:confirm]
      end

      def notify(type)
        if type == 'reset_password'
          @user.build_password_reset_token
          params = { user_email: @user.email,
                     link: @user.build_password_reset_url }
          NotificationsService.call('send password reset link', params: params)
        end
      end

      def email_provided?(email)
        string_empty_or_nil?(email)
      end

      def handle_email_not_provided
        render json: {
            error: 'email address required'
        }, status: :unprocessable_entity
      end

      def handle_email_provided
        if @user
          notify('reset_password')
          message = 'Password reset instructions sent to your email'
          responder('success', :ok, message: message)
        else
          error = 'email not found'
          responder('error', 422, error: error)
        end
      end
    end
  end
end
