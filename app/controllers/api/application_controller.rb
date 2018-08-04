class Api::ApplicationController < ActionController::API
  before_action :force_parse_json_request

  protected
  def force_parse_json_request
    request.format = :json
  end
end
