module ShellUtils
  module_function

  def say(text)
    puts text
  end

  def fail(text, code = 1)
    STDERR.puts text
    exit(code)
  end

  def say_status(status, text, color = :cyan)
    status = format "% 16s", status
    say "#{status.send(color)} #{text}"
  end
end

class String
  CLEAR = "\e[0m"

  { bold:       "\e[1m",
    black:      "\e[30m",
    red:        "\e[31m",
    green:      "\e[32m",
    yellow:     "\e[33m",
    blue:       "\e[34m",
    magenta:    "\e[35m",
    cyan:       "\e[36m",
    white:      "\e[37m",
    on_black:   "\e[40m",
    on_red:     "\e[41m",
    on_green:   "\e[42m",
    on_yellow:  "\e[43m",
    on_blue:    "\e[44m",
    on_magenta: "\e[45m",
    on_cyan:    "\e[46m",
    on_white:   "\e[47m",
  }.each do |color, code|
    define_method(color) do
      "#{code}#{self}#{CLEAR}"
    end
  end
end
