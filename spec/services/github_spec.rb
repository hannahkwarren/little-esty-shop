require 'rails_helper'

RSpec.describe GithubService do
  let(:github_api) {GithubService.new}
  it 'pases the api' do
    actual = github_api.repo_name
    expected = "little esty shop"
    expect(actual).to eq(expected)
  end
  describe '#user_names' do
    it 'returns the github usernames for the repo' do
      actual = github_api.user_names
      expected = "Eldridge-Turambi Malllll12 dkulback hannahkwarren"
      expect(actual).to eq(expected)
    end
  end
end
