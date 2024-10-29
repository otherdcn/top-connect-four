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

    context "checking validity of input" do
      let(:valid_point) { "E3" }
      let(:invalid_point) { ["EE3", "P3", "PP", "A", "4", ""] }

      context "given a valid point 'E3'" do
        it "raises no error" do
          expect { board.insert_disk(player_disk, valid_point) }.to_not raise_error
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

      before do
        board.instance_variable_set(:@points_marked, unavailable_points)
      end

      context "given an available input A3" do
        it "raises no error" do
          expect { board.insert_disk(player_disk, "A3") }.to_not raise_error
        end
      end

      context "given an unavailable input A6" do
        it "raises a StandardError instance" do
          expect { board.insert_disk(player_disk, unavailable_points[0]) }.to raise_error(StandardError, "Unavailable Point ID provided")
        end
      end

      context "given an available input B6" do
        it "raises a StandardError instance" do
          expect { board.insert_disk(player_disk, unavailable_points[1]) }.to raise_error(StandardError, "Unavailable Point ID provided")
        end
      end

      context "given an available input B5" do
        it "raises a StandardError instance" do
          expect { board.insert_disk(player_disk, unavailable_points[2]) }.to raise_error(StandardError, "Unavailable Point ID provided")
        end
      end

      context "given an available input E5" do
        it "raises a StandardError instance" do
          expect { board.insert_disk(player_disk, unavailable_points[6]) }.to raise_error(StandardError, "Unavailable Point ID provided")
        end
      end
    end
  end
end
