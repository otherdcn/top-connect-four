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

  describe "#insert_disk" do
    subject(:board) { described_class.new }
    let(:player_disk) { "X" }
    let(:points_ids) { %w[A2 B5 C1 D3 E4 F6 G4] }
    let(:points_id_coords) { [[1,0], [4,1], [0,2], [2,3], [3,4], [5,5], [3,6]] }

    context "checking validity of input" do
      let(:invalid_point) { ["EE3", "P3", "PP", "A", "4", ""] }

      context "given a valid point 'A6'" do
        it "raises no error" do
          expect { board.insert_disk(player_disk, "A6") }.to_not raise_error
        end
      end

      context "given an invalid point 'EE3'" do
        it "raises a StandardError instance" do
          expect { board.insert_disk(player_disk, invalid_point[0]) }.to raise_error(StandardError, "Invalid Point ID provided")
        end
      end

      context "given an invalid point 'P3'" do
        it "raises a StandardError instance" do
          expect { board.insert_disk(player_disk, invalid_point[1]) }.to raise_error(StandardError, "Invalid Point ID provided")
        end
      end

      context "given an invalid point 'PP'" do
        it "raises a StandardError instance" do
          expect { board.insert_disk(player_disk, invalid_point[2]) }.to raise_error(StandardError, "Invalid Point ID provided")
        end
      end

      context "given an invalid point 'A'" do
        it "raises a StandardError instance" do
          expect { board.insert_disk(player_disk, invalid_point[3]) }.to raise_error(StandardError, "Invalid Point ID provided")
        end
      end

      context "given an invalid point '4'" do
        it "raises a StandardError instance" do
          expect { board.insert_disk(player_disk, invalid_point[4]) }.to raise_error(StandardError, "Invalid Point ID provided")
        end
      end

      context "given an invalid point '' (empty string)" do
        it "raises a StandardError instance" do
          expect { board.insert_disk(player_disk, invalid_point[5]) }.to raise_error(StandardError, "Invalid Point ID provided")
        end
      end
    end

    context "checking availability of input" do
      let(:unavailable_points) { %w[A6 B6 B5 C6 D6 E6 E5] }
      let(:accessible_points) { %w[A5 B4 C5 D5 E4 F6 G6] }

      before do
        board.instance_variable_set(:@points_marked, unavailable_points)
        board.instance_variable_set(:@points_accessible, accessible_points)
      end

      context "given an available input A5" do
        it "raises no error" do
          expect { board.insert_disk(player_disk, "A5") }.to_not raise_error
        end
      end

      context "given an unavailable input A6" do
        it "raises a StandardError instance" do
          expect { board.insert_disk(player_disk, unavailable_points[0]) }.to raise_error(StandardError, "Unavailable Point ID provided")
        end
      end

      context "given an unavailable input B6" do
        it "raises a StandardError instance" do
          expect { board.insert_disk(player_disk, unavailable_points[1]) }.to raise_error(StandardError, "Unavailable Point ID provided")
        end
      end

      context "given an unavailable input B5" do
        it "raises a StandardError instance" do
          expect { board.insert_disk(player_disk, unavailable_points[2]) }.to raise_error(StandardError, "Unavailable Point ID provided")
        end
      end

      context "given an unavailable input E5" do
        it "raises a StandardError instance" do
          expect { board.insert_disk(player_disk, unavailable_points[6]) }.to raise_error(StandardError, "Unavailable Point ID provided")
        end
      end
    end

    context "checking accessibility of input" do
      it "raises no error given an accessible 'A6' point_id" do
        expect { board.insert_disk(player_disk, "A6") }.to_not raise_error
      end

      it "raises no error given an accessible 'B6' point_id" do
        expect { board.insert_disk(player_disk, "B6") }.to_not raise_error
      end

      it "raises no error given an accessible 'F6' point_id" do
        expect { board.insert_disk(player_disk, "F6") }.to_not raise_error
      end

      it "raises a StandardError instance given an inaccessible 'A5' point_id" do
        expect { board.insert_disk(player_disk, "A5") }.to raise_error(StandardError, "Blocked Point ID provided")
      end
    end

    context "translating the point_id into its respective grid position" do
      before do
        board.instance_variable_set(:@points_accessible, points_ids)
      end

      it "locates and returns 'A2' position" do
        point_id_coord = board.insert_disk(player_disk, points_ids[0])
        expect(point_id_coord).to eq(points_id_coords[0])
      end

      it "locates and returns 'G4' position" do
        point_id_coord = board.insert_disk(player_disk, points_ids[1])
        expect(point_id_coord).to eq(points_id_coords[1])
      end

      it "locates and returns 'C1' position" do
        point_id_coord = board.insert_disk(player_disk, points_ids[2])
        expect(point_id_coord).to eq(points_id_coords[2])
      end

      it "locates and returns 'F6' position" do
        point_id_coord = board.insert_disk(player_disk, points_ids[3])
        expect(point_id_coord).to eq(points_id_coords[3])
      end

      it "locates and returns 'E4' position" do
        point_id_coord = board.insert_disk(player_disk, points_ids[4])
        expect(point_id_coord).to eq(points_id_coords[4])
      end

      it "locates and returns 'D3' position" do
        point_id_coord = board.insert_disk(player_disk, points_ids[5])
        expect(point_id_coord).to eq(points_id_coords[5])
      end

      it "locates and returns 'B5' position" do
        point_id_coord = board.insert_disk(player_disk, points_ids[6])
        expect(point_id_coord).to eq(points_id_coords[6])
      end
    end

    context "adding disk to point_id's position in the grid" do
      before do
        board.instance_variable_set(:@points_accessible, points_ids)
      end

      it "changes the element's value for 'A2'" do
        row, col = points_id_coords[0]
        expect { board.insert_disk(player_disk, points_ids[0]) }.to change { board.grid[row][col] }.from(".").to(player_disk)
      end

      it "changes the element's value for 'B5'" do
        row, col = points_id_coords[1]
        expect { board.insert_disk(player_disk, points_ids[1]) }.to change { board.grid[row][col] }.from(".").to(player_disk)
      end

      it "changes the element's value for 'C1'" do
        row, col = points_id_coords[2]
        expect { board.insert_disk(player_disk, points_ids[2]) }.to change { board.grid[row][col] }.from(".").to(player_disk)
      end

      it "changes the element's value for 'D3'" do
        row, col = points_id_coords[3]
        expect { board.insert_disk(player_disk, points_ids[3]) }.to change { board.grid[row][col] }.from(".").to(player_disk)
      end

      it "changes the element's value for 'E4'" do
        row, col = points_id_coords[4]
        expect { board.insert_disk(player_disk, points_ids[4]) }.to change { board.grid[row][col] }.from(".").to(player_disk)
      end

      it "changes the element's value for 'F6'" do
        row, col = points_id_coords[5]
        expect { board.insert_disk(player_disk, points_ids[5]) }.to change { board.grid[row][col] }.from(".").to(player_disk)
      end

      it "changes the element's value for 'G4'" do
        row, col = points_id_coords[6]
        expect { board.insert_disk(player_disk, points_ids[6]) }.to change { board.grid[row][col] }.from(".").to(player_disk)
      end
    end

    context "adding point_id to points_marked array" do
      before do
        @points_marked = board.instance_variable_get(:@points_marked)
        board.instance_variable_set(:@points_accessible, points_ids.dup)
      end

      it do
        board.insert_disk(player_disk, points_ids[0])
        expect(@points_marked).to include(points_ids[0])
      end

      it do
        board.insert_disk(player_disk, points_ids[1])
        expect(@points_marked).to include(points_ids[1])
      end

      it do
        board.insert_disk(player_disk, points_ids[2])
        expect(@points_marked).to include(points_ids[2])
      end

      it do
        board.insert_disk(player_disk, points_ids[3])
        expect(@points_marked).to include(points_ids[3])
      end

      it do
        board.insert_disk(player_disk, points_ids[4])
        expect(@points_marked).to include(points_ids[4])
      end

      it do
        board.insert_disk(player_disk, points_ids[5])
        expect(@points_marked).to include(points_ids[5])
      end

      it do
        board.insert_disk(player_disk, points_ids[6])
        expect(@points_marked).to include(points_ids[6])
      end
    end

    context "replacing current accessible point_id with the above column point_id" do
      before do
        @points_accessible = board.instance_variable_get(:@points_accessible)
      end

      it do
        expect { board.insert_disk(player_disk, "B6") }.to change { @points_accessible[1] }.from("B6").to("B5")
      end

      it do
        expect { board.insert_disk(player_disk, "D6") }.to change { @points_accessible[3] }.from("D6").to("D5")
      end

      it do
        expect { board.insert_disk(player_disk, "F6") }.to change { @points_accessible[5] }.from("F6").to("F5")
      end

      it do
        expect { board.insert_disk(player_disk, "G6") }.to change { @points_accessible[6] }.from("G6").to("G5")
      end
    end
  end

  describe "#four_connected_in_a_row" do
    subject(:board_check) { described_class.new }
    let(:player_disk) { "X" }

    context "when none is found" do
      it do
        row_found = board_check.four_connected_in_a_row(player_disk)
        expect(row_found).to be_nil
      end
    end

    context "when only 1 in a row" do
      before do
        board_check.grid[3][3] = player_disk
      end

      it do
        row_found = board_check.four_connected_in_a_row(player_disk)
        expect(row_found).to be_nil
      end
    end

    context "when only 2 in a row " do
      before do
        row = 2 # index based
        start_col = 0
        start_col.upto(start_col + 1) { |col| board_check.grid[row][col] = player_disk }
      end

      it do
        row_found = board_check.four_connected_in_a_row(player_disk)
        expect(row_found).to be_nil
      end
    end

    context "when only 3 in a row" do
      before do
        row = 4 # index based
        start_col = 0
        start_col.upto(start_col + 2) { |col| board_check.grid[row][col] = player_disk }
      end

      it do
        row_found = board_check.four_connected_in_a_row(player_disk)
        expect(row_found).to be_nil
      end
    end

    context "when found in 6th row" do
      before do
        row = 5 # index based
        start_col = 0
        start_col.upto(start_col + 3) { |col| board_check.grid[row][col] = player_disk }
      end

      it do
        row_found = board_check.four_connected_in_a_row(player_disk)
        expect(row_found).to eq([[5,0], [5,1], [5,2], [5,3]])
      end
    end

    context "when found in 4th row" do
      before do
        row = 3 # index based
        start_col = 3
        start_col.upto(start_col + 3) { |col| board_check.grid[row][col] = player_disk }
      end

      it do
        row_found = board_check.four_connected_in_a_row(player_disk)
        expect(row_found).to eq([[3,3], [3,4], [3,5], [3,6]])
      end
    end

    context "when found in 1st row" do
      before do
        row = 0 # index based
        start_col = 2
        start_col.upto(start_col + 3) { |col| board_check.grid[row][col] = player_disk }
      end

      it do
        row_found = board_check.four_connected_in_a_row(player_disk)
        expect(row_found).to eq([[0,2], [0,3], [0,4], [0,5]])
      end
    end
  end
end
