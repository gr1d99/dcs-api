module Api
  module V1
    class TokensController < ApplicationController
      def verify
        type = verify_params[:type]
        token = verify_params[:token]
        handle_verification(type, token)
      end

      private

      def verify_params
        params.permit(:type, :token)
      end

      def handle_verification(type, token)
        if type == 'password_reset'
          handle_token_not_provided and return unless token_provided?(token)
          handle_token_provided(type, token)
        else
          type_not_implemented
        end
      end

      def handle_token_not_provided
        error_message = 'please ensure you have the correct url or request a new url'
        responder('error', 422, error: error_message)
      end

      def handle_token_provided(type, token)
        if User.token_valid?(type, token)
          responder('success', :ok, message: 'success!!')
        else
          error_message = 'please ensure you have the correct url or request a new url'
          responder('error', 422, error: error_message)
        end
      end

      def type_not_implemented
        responder('error', 422, error: 'not yet implemented!!')
      end

      def token_provided?(token)
        string_empty_or_nil?(token)
      end
    end
  end
end
