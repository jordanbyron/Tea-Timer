framework 'Cocoa'

class Controller
  attr_accessor :minutes_field, :seconds_field, :start_stop_button

  def awakeFromNib

  end

  def start_timer(sender)
    @start_stop_button = sender
    
    if @th && @th.alive?
      @th.exit
      enable_controls
      return -1
    end
    
    @start_stop_button.Title = "Stop"
    @minutes_field.setEnabled(false)
    @seconds_field.setEnabled(false)
    
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
      
      tea_done
    end
  end
  
  def tea_done
    puts "Tea's Done!"
    
    enable_controls
    
    NSApp.requestUserAttention(NSCriticalRequest)
    
    sound = NSSound.soundNamed("steam")
    sound.play
  end
  
  private
  attr_accessor :th
  
  def enable_controls
    @start_stop_button.title = "Start"
    @minutes_field.setEnabled(true)
    @seconds_field.setEnabled(true)
  end
end
