class Game
  class Frame
    def initialize(previous=nil)
      @previous = previous
    end

    def roll(pins)
      return next_frame_with(pins) if no_tries_available? || is_strike?

      if @first_try
        @second_try = pins
      else
        @first_try = pins
      end

      self
    end

    def score
      return compute_score unless @previous

      score = compute_score + @previous.score

      if @previous.is_strike?
        score += compute_score
      end

      score
    end

    def is_strike?
      compute_score == 10
    end

    private

    def compute_score
      return @first_try unless @second_try

      @first_try + @second_try
    end

    def next_frame_with(pins)
      child = Frame.new(self)
      child.roll(pins)
      child
    end

    def no_tries_available?
      !!@second_try
    end
  end

  def initialize
    @frame = Frame.new
  end

  def roll(pins)
    @frame = @frame.roll(pins)
  end

  def score
    @frame.score
  end
end

describe 'Game' do
  subject { Game.new }

  it 'computes the first try' do
    pins = non_strike_roll

    subject.roll(pins)

    expect(subject.score).to eq(pins)
  end

  it 'computes an strike in the first roll' do
    strike_roll = 10

    subject.roll(strike_roll)

    expect(subject.score).to eq(10)
  end

  it 'computes an strike in the second roll' do
    no_pins_roll = 0
    strike_roll = 10

    subject.roll(no_pins_roll)
    subject.roll(strike_roll)

    expect(subject.score).to eq(10)
  end

  it 'computes a roll after a strike' do
    strike_roll = 10

    subject.roll(strike_roll)
    subject.roll(1)

    expect(subject.score).to eq(12)
  end

  def non_strike_roll
    0.upto(9).to_a.shuffle.first
  end
end
