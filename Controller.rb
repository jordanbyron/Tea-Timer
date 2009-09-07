framework 'Cocoa'

class Controller
  attr_accessor :minutes_field, :seconds_field

  def awakeFromNib

  end

  def start_timer(sender)
    sender.Title = "Stop"
    
    seconds = @minutes_field.stringValue.to_i * 60 + @seconds_field.stringValue.to_i
    
    th = Thread.new do
      seconds.times do
        sleep(1)
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
end
