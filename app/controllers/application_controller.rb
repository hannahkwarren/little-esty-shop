class ApplicationController < ActionController::Base
  before_action :set_variables

  def set_variables
    @github = GithubService.new
  end
end
