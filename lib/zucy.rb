require "zucy/version"

module Zucy
  class Application

    def call(env)
      @req = Rack::Request.new(env)
      path = @req.path_info
      request_method = @req.request_method.downcase.to_sym
      return [500, {}, []] if path == "/favicon.ico"
      controller, action = get_controller_and_action_for(path)
      response = controller.new.send(action)
      [200, {"Content-Type" => "text/html"}, [response]]
    end

    def get_controller_and_action_for(path, verb)
      _, controller, action, others = path.split("/", 4)
      require "#{controller.downcase}_controller.rb"
      controller = Object.const_get(controller.capitalize! + "Controller")
      [controller, "#{verb}_#{action}"]
    end
  end
end