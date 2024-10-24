class Player
  attr_accessor :name, :token

  def initialize(name = "Regular Joe", token = "@")
    @name = name
    @token = token
  end
end
