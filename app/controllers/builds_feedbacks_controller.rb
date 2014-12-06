class BuildsFeedbacksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    builds_count = Build.where('updated_at >= ?', Time.parse(params[:from])).count

    if builds_count > 0
      render json: {from: Time.now}, status: :bad_request
    else
      head(200)
    end
  end
end