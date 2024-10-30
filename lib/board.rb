class Board
  attr_reader :grid, :key

  def initialize
    @grid = Array.new(6) { Array.new(7, ".") }
    @key = set_key
    @points_marked = []
    @points_allowed = @key.last
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
    raise StandardError, "Unavailable Point ID provided" unless available?(point_id)
    raise StandardError, "Blocked Point ID provided" unless allowed?(point_id)

    point_coord = get_point_id_coord(point_id)

    grid[point_coord[0]][point_coord[1]] = player_disk

    make_point_unavailable(point_id)

    replace_allowed_point_with_new(point_id)

    point_coord
  end

  def valid?(point_id)
    key.flatten.include?(point_id)
  end

  def available?(point_id)
    !@points_marked.include?(point_id)
  end

  def allowed?(point_id)
    @points_allowed.include?(point_id)
  end

  def get_point_id_coord(point_id)
    point_coord = nil

    key.each_with_index do |row_ele, row_idx|
      row_ele.each_with_index do |col_ele, col_idx|
        point_coord = [row_idx, col_idx] if point_id == col_ele
        break unless point_coord.nil?
      end
    end

    point_coord
  end

  def make_point_unavailable(point_id)
    @points_marked << point_id
  end

  def replace_allowed_point_with_new(point_id)
    row, col = point_id.split("")
    col = (col.to_i - 1).to_s

    @points_allowed[@points_allowed.index(point_id)] = row+col
  end

  private :set_key, :valid?, :available?, :get_point_id_coord, :make_point_unavailable, :replace_allowed_point_with_new
end
