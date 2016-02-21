class Time_man
  def initialize
    @time = Time.now
  end

  def time?
    return @time + 600 < Time.now
  end
end
