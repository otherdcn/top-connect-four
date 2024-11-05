require_relative "../lib/connect_four"

describe ConnectFour do
  describe "attributes" do
    it "creates a Board class instance" do
      expect(subject.board).to be_instance_of(Board)
    end

    it "creates a Player class instance" do
      expect(subject.player_one).to be_instance_of(Player)
    end
  end

  describe "#play" do
    subject(:game_play) { described_class.new }
    let(:board_play) { game_play.board }
    let(:player) { game_play.player_one }
    let(:point_id) { "A6" }
    let(:point_coord) { [5,0] }

    before do
      allow(game_play).to receive(:puts)
      allow(board_play).to receive(:display_grid)
      allow(game_play).to receive(:select_point_on_board).and_return(point_id)
      allow(board_play).to receive(:insert_token).with(player.token, point_id).and_return(point_coord)
      allow(game_play).to receive(:announce_winner)
    end

    context "when looping" do
      context "returning one true value by calling game_over?" do
        before do
          allow(game_play).to receive(:game_over?).with(player).and_return(true)
        end

        it "will complete one loop" do
          expect(game_play).to receive(:select_point_on_board).once
          game_play.play
        end
      end

      context "returning three falses and then one true by calling game_over?" do
        before do
          allow(game_play).to receive(:game_over?).and_return(false, false, false, true)
        end

        it "will complete four loops" do
          expect(game_play).to receive(:select_point_on_board).exactly(4).times
          game_play.play
        end
      end
    end

    context "when sending messages to Board" do
      before do
        allow(game_play).to receive(:game_over?).with(player).and_return(true)
      end

      it do
        expect(board_play).to receive(:display_grid)
        game_play.play
      end
    end
  end

  describe "#select_point_on_board" do
    subject(:game_input) { described_class.new(board_input) }
    let(:player) { game_input.player_one }
    let(:point_id) { "A6" }
    let(:point_coord) { [5,0] }
    let(:board_input) { instance_double(Board, insert_token: point_coord) }

    before do
      allow(game_input).to receive(:prompt_input).and_return(point_id)
    end

    context "when sending messages to Board" do
      it do
        expect(board_input).to receive(:insert_token).with(player.token, point_id)
        game_input.select_point_on_board(player)
      end
    end

    context "when either validity, availability, or accessibility, fails 3 times, and then a pass occurs the fourth time" do
      before do
        allow(board_input).to receive(:insert_token).and_return(nil, nil, nil, point_id)
      end

      it do
        expect(game_input).to receive(:prompt_input).exactly(4).times
        game_input.select_point_on_board(player)
      end
    end
  end

  describe "#game_over?" do
    subject(:game_check) { described_class.new }
    let(:board_check) { game_check.board }
    let(:player_one) { game_check.player_one }
    let(:player_two) { game_check.player_two }

    context "when there is a connect-4" do
      context "when the board grid has a row connect-4" do
        before do
          row = 5 # index based
          start_col = 0
          start_col.upto(start_col + 3) { |col| board_check.grid[row][col] = player_one.token }
        end

        it "returns true" do
          result = game_check.game_over?(player_one)
          expect(game_check).to be_game_over(player_one)
        end

        it "sets @winner to current player" do
          expect { game_check.game_over?(player_one) }.to change { game_check.instance_variable_get(:@winner) }.from(nil).to(player_one)
        end

        it "sets @winning_coords to returned message's value from board instance" do
          expect { game_check.game_over?(player_one) }.to change { game_check.instance_variable_get(:@winning_coords) }.from(nil).to([[5,0], [5,1], [5,2], [5,3]])
        end
      end

      context "when the board grid has a column connect-4" do
        before do
          col = 4 # index based
          start_row = 1
          start_row.upto(start_row + 3) { |row| board_check.grid[row][col] = player_two.token }
        end

        it "returns true" do
          result = game_check.game_over?(player_two)
          expect(game_check).to be_game_over(player_two)
        end

        it "sets @winner to current player" do
          expect { game_check.game_over?(player_two) }.to change { game_check.instance_variable_get(:@winner) }.from(nil).to(player_two)
        end

        it "sets @winning_coords to returned message's value from board instance" do
          expect { game_check.game_over?(player_two) }.to change { game_check.instance_variable_get(:@winning_coords) }.from(nil).to([[1,4], [2,4], [3,4], [4,4]])
        end
      end

      context "when the board grid has a diagonal connect-4" do
        before do
          row = 0
          col = 5

          4.times do |i|
            board_check.grid[row+i][col-i] = player_one.token
          end
        end

        it "returns true" do
          result = game_check.game_over?(player_one)
          expect(game_check).to be_game_over(player_one)
        end

        it "sets @winner to current player" do
          expect { game_check.game_over?(player_one) }.to change { game_check.instance_variable_get(:@winner) }.from(nil).to(player_one)
        end

        it "sets @winning_coords to returned message's value from board instance" do
          expect { game_check.game_over?(player_one) }.to change { game_check.instance_variable_get(:@winning_coords) }.from(nil).to([[0, 5], [1, 4], [2, 3], [3, 2]])
        end
      end
    end

    context "when there is no connect-4" do
      context "when the board grid only has a 3-in-a-row " do
        before do
          row = 5 # index based
          start_col = 0
          start_col.upto(start_col + 2) { |col| board_check.grid[row][col] = player_one.token }
        end

        it "returns false" do
          result = game_check.game_over?(player_one)
          expect(game_check).to_not be_game_over(player_one)
        end

        it "keeps @winner to nil" do
          expect { game_check.game_over?(player_one) }.to_not change { game_check.instance_variable_get(:@winner) }.from(nil)
        end

        it "keeps @winning_coords to nil" do
          expect { game_check.game_over?(player_one) }.to_not change { game_check.instance_variable_get(:@winning_coords) }.from(nil)
        end
      end

      context "when the board grid has 1-in-a-column" do
        before do
          col = 4 # index based
          start_row = 1
          start_row.upto(start_row + 1) { |row| board_check.grid[row][col] = player_two.token }
        end

        it "returns false" do
          result = game_check.game_over?(player_two)
          expect(game_check).to_not be_game_over(player_two)
        end

        it "keeps @winner to nil" do
          expect { game_check.game_over?(player_two) }.to_not change { game_check.instance_variable_get(:@winner) }.from(nil)
        end

        it "keeps @winning_coords to nil" do
          expect { game_check.game_over?(player_two) }.to_not change { game_check.instance_variable_get(:@winning_coords) }.from(nil)
        end
      end

      context "when the board grid only has 2-in-a-diagonal" do
        before do
          row = 0
          col = 5

          2.times do |i|
            board_check.grid[row+i][col-i] = player_one.token
          end
        end

        it "returns false" do
          result = game_check.game_over?(player_one)
          expect(game_check).to_not be_game_over(player_one)
        end

        it "keeps @winner to nil" do
          expect { game_check.game_over?(player_one) }.to_not change { game_check.instance_variable_get(:@winner) }.from(nil)
        end

        it "keeps @winning_coords to nil" do
          expect { game_check.game_over?(player_one) }.to_not change { game_check.instance_variable_get(:@winning_coords) }.from(nil)
        end
      end
    end
  end
end
