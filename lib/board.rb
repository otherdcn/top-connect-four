require 'colorize'

class Board
  attr_reader :grid, :key

  def initialize
    @grid = Array.new(6) { Array.new(7, ".") }
    @key = set_key
    @points_marked = []
    @points_accessible = @key.last
  end

  def insert_disk(player_disk, point_id)
    raise StandardError, "Invalid Point ID provided" unless valid?(point_id)
    raise StandardError, "Unavailable Point ID provided" unless available?(point_id)
    raise StandardError, "Blocked Point ID provided" unless accessible?(point_id)

    point_coord = get_point_id_coord(point_id)

    grid[point_coord[0]][point_coord[1]] = player_disk

    make_point_unavailable(point_id)

    replace_accessible_point_with_new(point_id)

    point_coord
  end

  def display_grid(marked_point = nil, winning_points = [])
    print "\n-------- Grid -------- ".center(31).underline
    print "-------- Key --------".center(31).underline
    puts ""
    point_padding = 4
    grid.each_with_index do |row, row_idx|
      key_row = key[row_idx]
      row.each_with_index do |point, point_idx|
        if marked_point == [row_idx, point_idx]
          print "#{point}".ljust(point_padding).colorize(:magenta)
        elsif winning_points.include?([row_idx, point_idx])
          print "#{point}".ljust(point_padding).colorize(:green)
        else
          print "#{point}".ljust(point_padding).colorize(:default)
        end

        next unless point_idx == 6

        print "|".center(10)

        key_row.each { |kdp| print kdp.ljust(point_padding)}

        puts "" if point_idx == 6
      end
    end
  end

  def four_connected_in_a_row(player_disk)
    four_in_a_row = nil

    grid.each_with_index do |row, row_idx|
      4.times do |col_idx|
        if row[col_idx] == player_disk &&
           row[col_idx + 1] == player_disk &&
           row[col_idx + 2] == player_disk &&
           row[col_idx + 3] == player_disk
          four_in_a_row = [
            [row_idx, col_idx],
            [row_idx, col_idx + 1],
            [row_idx, col_idx + 2],
            [row_idx, col_idx + 3]
          ]
        end
      end
      break if four_in_a_row
    end

    four_in_a_row
  end

  private

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

  def valid?(point_id)
    key.flatten.include?(point_id)
  end

  def available?(point_id)
    !@points_marked.include?(point_id)
  end

  def accessible?(point_id)
    @points_accessible.include?(point_id)
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

  def replace_accessible_point_with_new(point_id)
    row, col = point_id.split("")
    col = (col.to_i - 1).to_s

    @points_accessible[@points_accessible.index(point_id)] = row+col
  end
end
