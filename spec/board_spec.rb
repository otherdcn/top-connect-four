require_relative "../lib/board"

describe Board do
  describe "attributes" do
    it { expect(subject).to respond_to :grid }
    it { expect(subject).to respond_to :key }

    context "given the grid attribute" do
      before do
        @grid = subject.grid
      end

      it "is a multi-dimensional array" do
        grid_first_element = @grid.first
        grid_same_type = @grid.class == grid_first_element.class

        expect(grid_same_type).to eq true
      end

      it "has a default value of '.' for every element" do
        expect(@grid.flatten).to all( be_a(String).and include('.') )
      end
    end

    context "given the key attribute" do
      before do
        @key = subject.key
      end

      it "is a multi-dimensional array" do
        key_first_element = @key.first
        key_same_type = @key.class == key_first_element.class

        expect(key_same_type).to eq true
      end

      it "has the value of 'A1' as the first element " do
        expect(@key.flatten.first).to eq 'A1'
      end

      it "has the value of 'H8' as the last element " do
        expect(@key.flatten.last).to eq 'G6'
      end
    end
  end

  describe "#insert_token" do
    subject(:board) { described_class.new }
    let(:player_token) { "X" }
    let(:points_ids) { %w[A2 B5 C1 D3 E4 F6 G4] }
    let(:points_id_coords) { [[1,0], [4,1], [0,2], [2,3], [3,4], [5,5], [3,6]] }

    context "checking validity of input" do
      let(:invalid_point) { ["EE3", "P3", "PP", "A6", "4", ""] }

      context "given a valid point 'A'" do
        it "raises no error" do
          expect { board.insert_token(player_token, "A") }.to_not raise_error
        end
      end


      context "given a valid point 'F'" do
        it "raises no error" do
          expect { board.insert_token(player_token, "F") }.to_not raise_error
        end
      end

      context "given an  invalid point 'A6'" do
        it "raises StandardError instance" do
          expect { board.insert_token(player_token, invalid_point[3]) }.to raise_error(StandardError, "Column provided is invalid")
        end
      end

      context "given an invalid point 'EE3'" do
        it "raises a StandardError instance" do
          expect { board.insert_token(player_token, invalid_point[0]) }.to raise_error(StandardError, "Column provided is invalid")
        end
      end

      context "given an invalid point 'P3'" do
        it "raises a StandardError instance" do
          expect { board.insert_token(player_token, invalid_point[1]) }.to raise_error(StandardError, "Column provided is invalid")
        end
      end

      context "given an invalid point 'PP'" do
        it "raises a StandardError instance" do
          expect { board.insert_token(player_token, invalid_point[2]) }.to raise_error(StandardError, "Column provided is invalid")
        end
      end

      context "given an invalid point '4'" do
        it "raises a StandardError instance" do
          expect { board.insert_token(player_token, invalid_point[4]) }.to raise_error(StandardError, "Column provided is invalid")
        end
      end

      context "given an invalid point '' (empty string)" do
        it "raises a StandardError instance" do
          expect { board.insert_token(player_token, invalid_point[5]) }.to raise_error(StandardError, "Column provided is invalid")
        end
      end
    end

    context "checking accessibility of input" do
      before do
        board.instance_variable_set(:@points_accessible, %w[A5 B6 C6 D6 E6 F6 G0])
      end

      it "raises no error given an accessible 'A' point_id" do
        expect { board.insert_token(player_token, "A") }.to_not raise_error
      end

      it "raises no error given an accessible 'B' point_id" do
        expect { board.insert_token(player_token, "B") }.to_not raise_error
      end

      it "raises no error given an accessible 'F' point_id" do
        expect { board.insert_token(player_token, "F") }.to_not raise_error
      end

      it "raises a StandardError instance given an inaccessible 'G' point_id" do
        expect { board.insert_token(player_token, "G") }.to raise_error(StandardError, "Column provided is full")
      end
    end

    context "translating the point_id into its respective grid position" do
      before do
        board.instance_variable_set(:@points_accessible, points_ids)
      end

      it "locates and returns 'A' position" do
        point_id_coord = board.insert_token(player_token, "A")
        expect(point_id_coord).to eq(points_id_coords[0])
      end

      it "locates and returns 'G' position" do
        point_id_coord = board.insert_token(player_token, "G")
        expect(point_id_coord).to eq(points_id_coords[6])
      end

      it "locates and returns 'C' position" do
        point_id_coord = board.insert_token(player_token, "C")
        expect(point_id_coord).to eq(points_id_coords[2])
      end

      it "locates and returns 'F' position" do
        point_id_coord = board.insert_token(player_token, "F")
        expect(point_id_coord).to eq(points_id_coords[5])
      end

      it "locates and returns 'E' position" do
        point_id_coord = board.insert_token(player_token, "E")
        expect(point_id_coord).to eq(points_id_coords[4])
      end

      it "locates and returns 'D' position" do
        point_id_coord = board.insert_token(player_token, "D")
        expect(point_id_coord).to eq(points_id_coords[3])
      end

      it "locates and returns 'B' position" do
        point_id_coord = board.insert_token(player_token, "B")
        expect(point_id_coord).to eq(points_id_coords[1])
      end
    end

    context "adding disk to point_id's position in the grid" do
      before do
        board.instance_variable_set(:@points_accessible, points_ids)
      end

      it "changes the element's value for 'A2'" do
        row, col = points_id_coords[0]
        expect { board.insert_token(player_token, "A") }.to change { board.grid[row][col] }.from(".").to(player_token)
      end

      it "changes the element's value for 'B5'" do
        row, col = points_id_coords[1]
        expect { board.insert_token(player_token, "B") }.to change { board.grid[row][col] }.from(".").to(player_token)
      end

      it "changes the element's value for 'C1'" do
        row, col = points_id_coords[2]
        expect { board.insert_token(player_token, "C") }.to change { board.grid[row][col] }.from(".").to(player_token)
      end

      it "changes the element's value for 'D3'" do
        row, col = points_id_coords[3]
        expect { board.insert_token(player_token, "D") }.to change { board.grid[row][col] }.from(".").to(player_token)
      end

      it "changes the element's value for 'E4'" do
        row, col = points_id_coords[4]
        expect { board.insert_token(player_token, "E") }.to change { board.grid[row][col] }.from(".").to(player_token)
      end

      it "changes the element's value for 'F6'" do
        row, col = points_id_coords[5]
        expect { board.insert_token(player_token, "F") }.to change { board.grid[row][col] }.from(".").to(player_token)
      end

      it "changes the element's value for 'G4'" do
        row, col = points_id_coords[6]
        expect { board.insert_token(player_token, "G") }.to change { board.grid[row][col] }.from(".").to(player_token)
      end
    end

    context "replacing current accessible point_id with the above column point_id" do
      before do
        @points_accessible = board.instance_variable_get(:@points_accessible)
      end

      it do
        expect { board.insert_token(player_token, "B") }.to change { @points_accessible[1] }.from("B6").to("B5")
      end

      it do
        expect { board.insert_token(player_token, "D") }.to change { @points_accessible[3] }.from("D6").to("D5")
      end

      it do
        expect { board.insert_token(player_token, "F") }.to change { @points_accessible[5] }.from("F6").to("F5")
      end

      it do
        expect { board.insert_token(player_token, "G") }.to change { @points_accessible[6] }.from("G6").to("G5")
      end
    end
  end

  describe "#four_connected_in_a_row" do
    subject(:board_check) { described_class.new }
    let(:player_token) { "X" }

    context "when none is found" do
      it do
        row_found = board_check.four_connected_in_a_row(player_token)
        expect(row_found).to be_nil
      end
    end

    context "when only 1 in a row" do
      before do
        board_check.grid[3][3] = player_token
      end

      it do
        row_found = board_check.four_connected_in_a_row(player_token)
        expect(row_found).to be_nil
      end
    end

    context "when only 2 in a row " do
      before do
        row = 2 # index based
        start_col = 0
        start_col.upto(start_col + 1) { |col| board_check.grid[row][col] = player_token }
      end

      it do
        row_found = board_check.four_connected_in_a_row(player_token)
        expect(row_found).to be_nil
      end
    end

    context "when only 3 in a row" do
      before do
        row = 4 # index based
        start_col = 0
        start_col.upto(start_col + 2) { |col| board_check.grid[row][col] = player_token }
      end

      it do
        row_found = board_check.four_connected_in_a_row(player_token)
        expect(row_found).to be_nil
      end
    end

    context "when found in 6th row" do
      before do
        row = 5 # index based
        start_col = 0
        start_col.upto(start_col + 3) { |col| board_check.grid[row][col] = player_token }
      end

      it do
        row_found = board_check.four_connected_in_a_row(player_token)
        expect(row_found).to eq([[5,0], [5,1], [5,2], [5,3]])
      end
    end

    context "when found in 4th row" do
      before do
        row = 3 # index based
        start_col = 3
        start_col.upto(start_col + 3) { |col| board_check.grid[row][col] = player_token }
      end

      it do
        row_found = board_check.four_connected_in_a_row(player_token)
        expect(row_found).to eq([[3,3], [3,4], [3,5], [3,6]])
      end
    end

    context "when found in 1st row" do
      before do
        row = 0 # index based
        start_col = 2
        start_col.upto(start_col + 3) { |col| board_check.grid[row][col] = player_token }
      end

      it do
        row_found = board_check.four_connected_in_a_row(player_token)
        expect(row_found).to eq([[0,2], [0,3], [0,4], [0,5]])
      end
    end
  end

  describe "#four_connected_in_a_column" do
    subject(:board_check) { described_class.new }
    let(:player_token) { "X" }

    context "when none is found" do
      it do
        col_found = board_check.four_connected_in_a_column(player_token)
        expect(col_found).to be_nil
      end
    end

    context "when only 1 in a column" do
      before do
        board_check.grid[1][1] = player_token
      end

      it do
        col_found = board_check.four_connected_in_a_column(player_token)
        expect(col_found).to be_nil
      end
    end

    context "when only 2 in a column" do
      before do
        start_row = 0
        col = 0
        start_row.upto(start_row + 1) { |row| board_check.grid[row][col] = player_token }
      end

      it do
        col_found = board_check.four_connected_in_a_column(player_token)
        expect(col_found).to be_nil
      end
    end

    context "when only 3 in a column" do
      before do
        start_row = 0
        col = 0
        start_row.upto(start_row + 2) { |row| board_check.grid[row][col] = player_token }
      end

      it do
        col_found = board_check.four_connected_in_a_column(player_token)
        expect(col_found).to be_nil
      end
    end

    context "when found in the 2nd column" do
      before do
        col = 1 # index based
        start_row = 2
        start_row.upto(start_row + 3) { |row| board_check.grid[row][col] = player_token }
      end

      it do
        column_found = board_check.four_connected_in_a_column(player_token)
        expect(column_found).to eq([[2,1], [3,1], [4,1], [5,1]])
      end
    end

    context "when found in the 3rd column" do
      before do
        col = 2 # index based
        start_row = 0
        start_row.upto(start_row + 3) { |row| board_check.grid[row][col] = player_token }
      end

      it do
        column_found = board_check.four_connected_in_a_column(player_token)
        expect(column_found).to eq([[0,2], [1,2], [2,2], [3,2]])
      end
    end

    context "when found in the 5th column" do
      before do
        col = 4 # index based
        start_row = 1
        start_row.upto(start_row + 3) { |row| board_check.grid[row][col] = player_token }
      end

      it do
        column_found = board_check.four_connected_in_a_column(player_token)
        expect(column_found).to eq([[1,4], [2,4], [3,4], [4,4]])
      end
    end

    context "when found in the 6th column" do
      before do
        col = 5 # index based
        start_row = 2
        start_row.upto(start_row + 3) { |row| board_check.grid[row][col] = player_token }
      end

      it do
        column_found = board_check.four_connected_in_a_column(player_token)
        expect(column_found).to eq([[2,5], [3,5], [4,5], [5,5]])
      end
    end
  end

  describe "#four_connected_in_a_diagonal" do
    subject(:board_check) { described_class.new }
    let(:player_token) { "X" }

    context "when none is found" do
      it do
        diag_found = board_check.four_connected_in_a_diagonal(player_token)
        expect(diag_found).to be_nil
      end
    end

    context "when only 1 in a diagonal" do
      before do
        board_check.grid[2][3] = player_token
      end

      it do
        diag_found = board_check.four_connected_in_a_diagonal(player_token)
        expect(diag_found).to be_nil
      end
    end

    context "when only 2 in a diagonal" do
      before do
        row = 0
        col = 2

        2.times do |i|
          board_check.grid[row+i][col+i] = player_token
        end
      end

      it do
        diag_found = board_check.four_connected_in_a_diagonal(player_token)
        expect(diag_found).to be_nil
      end
    end

    context "when only 3 in a diagonal" do
      before do
        row = 0
        col = 2

        3.times do |i|
          board_check.grid[row+i][col+i] = player_token
        end
      end

      it do
        diag_found = board_check.four_connected_in_a_diagonal(player_token)
        expect(diag_found).to be_nil
      end
    end

    context "diagonals from left to right" do
      context "when found starting from co-ordinate [1,0]" do
        before do
          row = 1
          col = 0

          4.times do |i|
            board_check.grid[row+i][col+i] = player_token
          end
        end

        it do
          diag_found = board_check.four_connected_in_a_diagonal(player_token)
          expect(diag_found).to eq([[1,0], [2,1], [3,2], [4,3]])
        end
      end

      context "when found starting from co-ordinate [2,3]" do
        before do
          row = 2
          col = 3

          4.times do |i|
            board_check.grid[row+i][col+i] = player_token
          end
        end

        it do
          diag_found = board_check.four_connected_in_a_diagonal(player_token)
          expect(diag_found).to eq([[2,3], [3,4], [4,5], [5,6]])
        end
      end
    end

    context "diagonals from right to left" do
      context "when found starting from co-ordinate [0,5]" do
        before do
          row = 0
          col = 5

          4.times do |i|
            board_check.grid[row+i][col-i] = player_token
          end
        end

        it do
          diag_found = board_check.four_connected_in_a_diagonal(player_token)
          expect(diag_found).to eq([[0,5], [1,4], [2,3], [3,2]])
        end
      end

      context "when found starting from co-ordinate [2,3]" do
        before do
          row = 2
          col = 3

          4.times do |i|
            board_check.grid[row+i][col-i] = player_token
          end
        end

        it do
          diag_found = board_check.four_connected_in_a_diagonal(player_token)
          expect(diag_found).to eq([[2,3], [3,2], [4,1], [5,0]])
        end
      end
    end
  end
end
