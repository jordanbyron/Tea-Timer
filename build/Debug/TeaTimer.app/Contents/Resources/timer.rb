class Timer
  require 'monitor'

  def initialize(secPerTick = 0.1)
    @secPerTick = secPerTick
    @events = {}
    @events.extend(MonitorMixin)
    Thread.new { timer_task }

    class << self
      attr_reader :secPerTick
    end
  end

  private

  def timer_task
    while true
      thisTick = toTick(Time.now)
      @events.synchronize do
        if(@events.has_key?(thisTick))
          @events[thisTick].each { |r| r.call }
          @events.delete(thisTick)
        end
      end
      nextTick = toTick(Time.now+@secPerTick)
      sleep(nextTick - Time.now.to_f)
    end
  end

  public

  def toTick(t)

    #
    # round down to the nearset tick

    @secPerTick * (t.to_f/@secPerTick).to_i
  end

  def remind_at(atTime, &receiver)
    t = toTick(atTime)
    @events.synchronize do
      if(!@events.has_key?(t))
        @events[t]=[] # time => [callbacks]
      end
      @events[t] << receiver
      @events[t].uniq!
    end
  end

  def remind_in(inTime, &receiver)
    remind_at(Time.now+inTime, &receiver)
  end

end

def testTimer
  curTime = Time.now
  def helloThere
    print "hello there, in thread ", Thread.current, " it's ", Time.now.to_f, "\n"
  end
  def middleGreeting
    print "in the middle, in thread ", Thread.current, " it's ", Time.now.to_f, "\n"
  end
  def goodbyeThen
    print "goodbye then, in thread ", Thread.current, " it's ", Time.now.to_f, "\n"
  end

  reminders=Timer.new(0.1)
  print "in the beginning, in thread ", Thread.current, " it was ", curTime.to_f, "\n"

  threads = []
  1.upto(2) do
    threads << Thread.new {
      reminders.remind_at(curTime+10) { goodbyeThen }
      reminders.remind_at(curTime+1) { helloThere }
      reminders.remind_in(1) { middleGreeting }
      sleep 11
    }
    sleep 0.1
  end
  threads.each {|t| t.join}
  sleep(11)
end