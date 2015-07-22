require 'json'

module Changefindrapi
  class API < Grape::API
    version using: :header, vendor: 'changefindr'
    format :json
    prefix :api

    helpers do
      def save_api_request(request)


        api_request = ApiRequest.new
        #byebug
        api_request.request_object = request.to_s
        api_request.created = Time.now
        api_request.save

      end

      def authenticate!
        @account = Account.where(api_key: params['api_key']).first

        if @account != nil

          account_url = AccountUrl.where(account_id: @account.id)
                                   .where(access_url: headers['Host']).first
        
          if account_url != nil
            return true
          else
            error!('401 Unauthorized', 401)
          end

        else
          error!('401 Unauthorized', 401)
        end

      end
    end

    # global handler for simple not found case
    rescue_from ActiveRecord::RecordNotFound do |e|
      error_response(message: e.message, status: 404)
    end

    # global exception handler, used for error notifications
    rescue_from :all do |e|
      if Rails.env.development?
        raise e
      else
        Raven.capture_exception(e)
        error_response(message: "Internal server error", status: 500)
      end
    end

    resource :causes do

      desc "Return causes"
      get :get_causes do

        #byebug

        save_api_request(request)

        authenticate!
        
        causes = Charity.limit(2)

      end
     
    end

  add_swagger_documentation

  end


end