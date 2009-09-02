require 'timer'

class Controller
  attr_writer :minutesField, :secondsField

  def awakeFromNib

  end

  def startTimer(sender)
    sender.Title = "Stop"
    
    seconds = @minutesField.stringValue.to_i * 60 + @secondsField.stringValue.to_i
    
    th = Thread.new do
      sleep(seconds)
      puts "Tea's Done!"
      sender.Title = "Start"
    end
  end
end
