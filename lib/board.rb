require 'colorize'

class Board
  attr_reader :grid, :key

  def initialize
    @grid = Array.new(6) { Array.new(7, ".") }
    @key = set_key
    @points_available = @key.last.dup
  end

  def insert_token(player_token, column)
    raise StandardError, "Column provided is invalid" unless valid?(column)
    raise StandardError, "Column provided is full" unless available?(column)

    point_coord = get_column_coord(column)

    grid[point_coord[0]][point_coord[1]] = player_token

    replace_available_point_with_new(column)

    point_coord
  end

  def display_grid(marked_point = nil, winning_points = [])
    puts "\n-------- Grid -------- ".center(25)

    puts %w[ A B C D E F G].join(" ".ljust(3)).black.on_yellow

    point_padding = 4

    grid.each_with_index do |row, row_idx|
      key_row = key[row_idx]
      row.each_with_index do |point, column_idx|
        if marked_point == [row_idx, column_idx]
          print "#{point}".ljust(point_padding).colorize(:magenta)
        elsif winning_points.include?([row_idx, column_idx])
          print "#{point}".ljust(point_padding).colorize(:green)
        else
          print "#{point}".ljust(point_padding).colorize(:default)
        end

        next unless column_idx == 6

        puts "" if column_idx == 6
      end
    end
  end

  def four_connected_in_a_row(player_token)
    four_in_a_row = nil

    grid.each_with_index do |row, row_idx|
      4.times do |col_idx|
        if row[col_idx] == player_token &&
           row[col_idx + 1] == player_token &&
           row[col_idx + 2] == player_token &&
           row[col_idx + 3] == player_token
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

  def four_connected_in_a_column(player_token)
    four_in_a_column = nil
    columns_to_scan = grid.first.size
    rows_to_scan = 3

    columns_to_scan.times do |column_to_scan|

      rows_to_scan.times do |row_to_scan|

        next unless grid[row_to_scan][column_to_scan] == player_token &&
          grid[row_to_scan + 1][column_to_scan] == player_token &&
          grid[row_to_scan + 2][column_to_scan] == player_token &&
          grid[row_to_scan + 3][column_to_scan] == player_token

        four_in_a_column = [
          [row_to_scan, column_to_scan],
          [row_to_scan+1, column_to_scan],
          [row_to_scan+2, column_to_scan],
          [row_to_scan+3, column_to_scan],
        ]

        break if four_in_a_column
      end

      break if four_in_a_column
    end

    four_in_a_column
  end

  def four_connected_in_a_diagonal(player_token)
    scan_from_left  = left_to_right_diagonal(player_token)
    return scan_from_left unless scan_from_left.nil?

    right_to_left_diagonal(player_token)
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

  def valid?(column)
    %w[A B C D E F G].include?(column)
  end

  def available?(column)
    !@points_available.find { |point| point.split("").first == column }
                       .split("")[1].to_i.zero?
  end

  def get_column_coord(column)
    full_point = @points_available.find { |point| point.split("").first == column }

    point_coord = nil

    key.each_with_index do |row_ele, row_idx|
      row_ele.each_with_index do |col_ele, col_idx|
        point_coord = [row_idx, col_idx] if full_point == col_ele
        break unless point_coord.nil?
      end
    end

    point_coord
  end

  def replace_available_point_with_new(column)
    full_point = @points_available.find { |point| point.split("").first == column }
    row, col = full_point.split("")
    col = (col.to_i - 1).to_s

    @points_available[@points_available.index(full_point)] = row+col
  end

  def left_to_right_diagonal(player_token)
    four_in_a_diag = nil
    columns_to_scan = 4
    rows_to_scan = 3

    columns_to_scan.times do |column_to_scan|

      rows_to_scan.times do |row_to_scan|
        next unless grid[row_to_scan][column_to_scan] == player_token &&
          grid[row_to_scan + 1][column_to_scan + 1] == player_token &&
          grid[row_to_scan + 2][column_to_scan + 2] == player_token &&
          grid[row_to_scan + 3][column_to_scan + 3] == player_token

        four_in_a_diag = [
          [row_to_scan, column_to_scan],
          [row_to_scan+1, column_to_scan+1],
          [row_to_scan+2, column_to_scan+2],
          [row_to_scan+3, column_to_scan+3],
        ]

        break if four_in_a_diag
      end

      break if four_in_a_diag
    end

    four_in_a_diag
  end

  def right_to_left_diagonal(player_token)
    four_in_a_diag = nil
    #columns_to_scan = 3.upto(6).reverse_each
    columns_to_scan = [6,5,4,3]
    rows_to_scan = 3

    #columns_to_scan.tap { |x| x.to_a }.map(&:to_i).each do |column_to_scan|
    columns_to_scan.each do |column_to_scan|

      rows_to_scan.times do |row_to_scan|
        next unless grid[row_to_scan][column_to_scan] == player_token &&
          grid[row_to_scan + 1][column_to_scan - 1] == player_token &&
          grid[row_to_scan + 2][column_to_scan - 2] == player_token &&
          grid[row_to_scan + 3][column_to_scan - 3] == player_token

        four_in_a_diag = [
          [row_to_scan, column_to_scan],
          [row_to_scan+1, column_to_scan-1],
          [row_to_scan+2, column_to_scan-2],
          [row_to_scan+3, column_to_scan-3],
        ]

        break if four_in_a_diag
      end

      break if four_in_a_diag
    end

    four_in_a_diag
  end
end
