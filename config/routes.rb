Rails.application.routes.draw do
  resources :parsed_email_records

  get "/captcha/pokemon", to: "captcha#show"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  # 只在特定条件下启用 Rails Conductor
  if Rails.env.development? || ENV['ENABLE_RAILS_CONDUCTOR'] == 'true'
    # 添加认证中间件
    class ConductorAuth
      def initialize(app)
        @app = app
      end

      def call(env)
        if env['PATH_INFO'].start_with?('/rails/conductor')
          # 简单的 HTTP Basic Auth
          auth = Rack::Auth::Basic.new(@app) do |username, password|
            username == ENV['CONDUCTOR_USERNAME'] && password == ENV['CONDUCTOR_PASSWORD']
          end
          auth.call(env)
        else
          @app.call(env)
        end
      end
    end

    # 应用认证中间件
    Rails.application.config.middleware.use ConductorAuth
  end
end
