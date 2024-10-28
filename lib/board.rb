class Board
  attr_reader :grid, :key

  def initialize
    @grid = Array.new(3) { Array.new(3, ".") }
    @key = set_key
  end

  def set_key
    column_ids = "A".upto("H").map(&:to_s)
    row_ids = "1".upto("8").map(&:to_s)
    final_board = []

    row_ids.map do |rank|
      row = []
      column_ids.map do |file|
        row << file+rank
      end
      final_board << row
      row = []
    end

    final_board
  end

  private :set_key
end
