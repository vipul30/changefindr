module Changefindrapi
  class API < Grape::API
    #version 'v1', using: :header, vendor: 'changefindr'
    format :json
    prefix :api

    helpers do
      def current_user
        @current_user ||= User.authorize!(env)
      end

      def authenticate!
        error!('401 Unauthorized', 401) unless current_user
      end
    end

    resource :causes do

      desc "Return causes"
      get :get_causes do

        causes = Charity.limit(20)
        return causes
      end

     
    end
  end
end