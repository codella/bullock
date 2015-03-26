require 'bullock/parse/track'
require 'bullock/parse/production'

describe Bullock::Parse::Track do
  describe ".from_production" do
    it "creates a track that points to 0" do
      production = Bullock::Parse::Production.new(:symbol, 'first second') {}

      track = Bullock::Parse::Track.from_production(production)

      expect(track.pointed[:symbol]).to be :first
    end
  end

  describe "#proceed" do
    it "creates a new track pointing to the following symbol" do
      production = Bullock::Parse::Production.new(:symbol, 'first second') {}
      track = Bullock::Parse::Track.from_production(production)

      expect(track.proceed.pointed[:symbol]).to eq :second
    end

    it "creates a new track pointing to :EOT if already pointing at the end" do
      production = Bullock::Parse::Production.new(:symbol, 'first') {}
      track = Bullock::Parse::Track.from_production(production)

      expect(track.proceed.pointed).to eq :EOT
    end

    it "keeps returning tracks pointing to :EOT if already pointing at the end" do
      production = Bullock::Parse::Production.new(:symbol, 'first') {}
      track = Bullock::Parse::Track.from_production(production)

      expect(track.proceed.proceed.pointed).to eq :EOT
    end
  end
end
