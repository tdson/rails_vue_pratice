class ApplicationController < ActionController::API
  before_action :force_parse_json_request

  protected
  def render_404 message: "Not found!"
    render json: {message: message}, status: 404
  end

  def force_parse_json_request
    request.format = :json
  end
end
