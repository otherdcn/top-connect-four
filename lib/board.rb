class Board
  attr_reader :grid, :key

  def initialize
    @grid = Array.new(6) { Array.new(7, ".") }
    @key = set_key
    @points_marked = []
  end

  def set_key
    column_ids = "A".upto("G").map(&:to_s)
    row_ids = "1".upto("6").map(&:to_s)
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

  def insert_disk(player_disk, point_id)
    raise StandardError, "Invalid Point ID provided" unless valid?(point_id)
    raise StandardError, "Unavailable Point ID provided" if available?(point_id)
  end

  def valid?(point_id)
    key.flatten.include?(point_id)
  end

  def available?(point_id)
    @points_marked.include?(point_id)
  end

  private :set_key
end
