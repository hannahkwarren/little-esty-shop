class GithubService
  def repo_name
    api = get_url("little-esty-shop")
    api[:name]
  end
  def user_names
    api = get_url("little-esty-shop/contributors")
    users = []
    api.find_all do |user|
      if user[:login] == "hannahkwarren"
        users << user[:login]
      elsif user[:login] == "Malllll12"
        users << user[:login]
      elsif user[:login] == "dkulback"
        users << user[:login]
      elsif user[:login] == "Eldridge-Turambi"
        users << user[:login]
      end
    end
    users.sort.join(' ')
  end
  def get_url(url)
    response = HTTParty.get "https://api.github.com/repos/hannahkwarren/#{url}"
    pared = JSON.parse(response.body, symbolize_names: true)
  end
end
