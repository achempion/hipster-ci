class Triggers::GithubsController < Triggers::BaseController

  def create
    render json: github_params, status: :ok
  end

  private

  def github_params
    params.permit(:after, repository: :full_name)
  end

end