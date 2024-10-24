require_relative "../lib/player"

describe Player do
  describe "attributes" do
    
    it { expect(subject).to respond_to :name }
    it { expect(subject).to respond_to :token }
    it { expect(subject).to respond_to :name= }
    it { expect(subject).to respond_to :token= }

    context "given no arguments during instantiation" do
      subject(:player_default) { described_class.new }

      it "returns 'Regular Joe' as default string for name" do
        expect(player_default.name).to eq "Regular Joe"
      end

      it "returns '@' as default character string for token" do
        expect(player_default.token).to eq "@"
      end
    end
  end
end
