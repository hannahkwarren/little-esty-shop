class GithubService

  def repo_name
    api = get_url("little-esty-shop")
    api[:name]
  end

  def user_names_and_commits
    api = get_url("little-esty-shop/contributors")
    users = {}
    api.find_all do |user|
      if user[:login] == "hannahkwarren"
        users[user[:login]] = user[:contributions]
      elsif user[:login] == "Malllll12"
        users[user[:login]] = user[:contributions]
      elsif user[:login] == "dkulback"
        users[user[:login]] = user[:contributions]
      elsif user[:login] == "Eldridge-Turambi"
        users[user[:login]] = user[:contributions]
      end
    end
    users
  end

  def user_pr
    api = get_url("little-esty-shop/pulls?state=closed")
    api[0][:number]
  end

  def get_url(url)
    response = HTTParty.get "https://api.github.com/repos/hannahkwarren/#{url}"
    pared = JSON.parse(response.body, symbolize_names: true)
  end
end
