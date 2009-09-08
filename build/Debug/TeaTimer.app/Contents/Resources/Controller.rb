framework 'Cocoa'

class Controller
  attr_accessor :minutes_field, :seconds_field

  def awakeFromNib

  end

  def start_timer(sender)
    if @th && @th.alive?
      @th.exit
      sender.title = "Start"
      return -1
    end
    
    sender.Title = "Stop"
    
    seconds = @minutes_field.stringValue.to_i * 60 + @seconds_field.stringValue.to_i
    
    @th = Thread.new do
      seconds.times do
        sleep(1)
        
        if @seconds_field.stringValue.to_i == 0 && @minutes_field.stringValue.to_i > 0
          @minutes_field.stringValue = @minutes_field.stringValue.to_i - 1
          @seconds_field.stringValue = 60
        end
        
        @seconds_field.stringValue = @seconds_field.stringValue.to_i - 1
      end
      
      puts "Tea's Done!"
      sender.Title = "Start"
      tea_done
    end
  end
  
  def tea_done
    NSApp.requestUserAttention(NSCriticalRequest)
    
    sound = NSSound.soundNamed("steam")
    sound.play
  end
  
  private
  attr_accessor :th
end
