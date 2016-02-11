class Time_man
  def initialize
    @time = Time.now
  end

  def time?
    return @time + 10 < Time.now
  end

end

clock = Time_man.new
sleep 12
puts clock.time?
