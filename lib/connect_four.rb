require_relative 'board'
require_relative 'player'

class ConnectFour
  attr_reader :board, :player_one, :player_two

  def initialize(board_ins = Board.new)
    @board = board_ins
    @player_one = Player.new("Player One", "X")
    @player_two = Player.new("Player Two", "O")
  end

  def play
    point_coord = nil
    winner = nil
    winning_coords = []

    loop do
      [player_one, player_two].each do |player|
        puts "#{player.name}: your turn to play!"

        board.display_grid(point_coord)

        point_coord = select_point_on_board(player)

        next unless game_over?(player)

        winner = player
        winning_coords = game_over?(player)
        break if winner
      end

      break if winner
    end

    announce_winner
  end

  def select_point_on_board(player)
    point_coord = nil

    loop do
      begin
      input = prompt_input

      point_coord = board.insert_disk(player.token, input.upcase)
      rescue StandardError => msg
        puts msg
      end

      break if point_coord
    end

    point_coord
  end

  def prompt_input
    print "Enter point: "
    gets.chomp
  end

  def game_over?(player)
    if board.four_connected_in_a_row(player.token)
      @winning_coords = board.four_connected_in_a_row(player.token)
      @winner = player
      return true
    elsif board.four_connected_in_a_column(player.token)
      @winning_coords = board.four_connected_in_a_column(player.token)
      @winner = player
      return true
    elsif board.four_connected_in_a_diagonal(player.token)
      @winning_coords = board.four_connected_in_a_diagonal(player.token)
      @winner = player
      return true
    else
      return false
    end
  end

  def announce_winner
  end
end
