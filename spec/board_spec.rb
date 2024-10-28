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
        expect(@key.flatten.last).to eq 'H8'
      end
    end
  end
end
