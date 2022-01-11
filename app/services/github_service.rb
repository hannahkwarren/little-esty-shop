class GithubService
  def repo_name
    api = get_url("little-esty-shop")
    require "pry"; binding.pry
  end
  def get_url(url)
    response = HTTParty.get "https://api.github.com/repos/hannahkwarren/#{url}"
    pared = JSON.parse(response.body, symbolize_names: true)

  end
end
