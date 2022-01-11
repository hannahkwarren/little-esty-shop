require 'rails_helper'

RSpec.describe GithubService do
  let(:github_api) {GithubService.new}
  it 'pases the api' do
    actual = github_api.repo_name
    expected = "little esty shop"
    expect(actual).to eq(expected)
  end
end
