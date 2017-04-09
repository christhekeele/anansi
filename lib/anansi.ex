defmodule Anansi do
  @moduledoc """
  Utilities to work with ANSI escape sequences.

  [ANSI escape instructions](https://en.wikipedia.org/wiki/ANSI_escape_code) are
  strings that can be sent to the terminal to control its screen, pager, and cursor;
  and manage the formatting, font, and color of the text it displays.
  """

  import Anansi.Sequence, only: [compose: 1, compose: 2]

  @doc """
  Detects if ANSI is currently supported (stdin and stdout are ttys).
  """
  def enabled? do
    Application.get_env(:elixir, :ansi_enabled, false)
  end

  @doc """
  Generates an instruction from the given `codes` and `terminal` code.
  """
  def escape(codes \\ [], terminal) do
    "\e[" <> Enum.map_join(List.wrap(codes), ";", &to_string/1) <> terminal
  end

  @doc """
  Clears entire screen.
  """
  def clear do
    compose(cursor: [:home, erase: :screen])
  end

  @doc """
  Generates an ANSI instruction that applies the given `setting` to control `type`.
  """
  def instruction(type, setting)

####
# TEXT RESET
##

  def instruction(:text, :reset) do
    escape 0, "m"
  end

####
# TEXT FORMATS
##

  def instruction(:bold, :on) do
    escape 1, "m"
  # after
  #   instruction :bold, :off
  end
  def instruction(:bold, :off) do
    escape 21, "m"
  # after
  #   instruction :bold, :on
  end

  def instruction(:faint, :on) do
    escape 2, "m"
  # after
  #   instruction :faint, :off
  end
  def instruction(:faint, :off) do
    escape 22, "m"
  # after
  #   instruction :faint, :on
  end

  def instruction(:italic, :on) do
    escape 3, "m"
  # after
  #   instruction :italic, :off
  end
  def instruction(:italic, :off) do
    escape 23, "m"
  # after
  #   instruction :italic, :on
  end

  def instruction(:underline, :on) do
    escape 4, "m"
  # after
  #   instruction :underline, :off
  end
  def instruction(:underline, :off) do
    escape 24, "m"
  # after
  #   instruction :underline, :on
  end

  def instruction(:blink, :slow) do
    escape 5, "m"
  # after
  #   instruction :blink, :off
  end
  def instruction(:blink, :fast) do
    escape 6, "m"
  # after
  #   instruction :blink, :off
  end
  def instruction(:blink, :off) do
    escape 25, "m"
  end

  def instruction(:invert, :on) do
    escape 7, "m"
  # after
  #   instruction :invert, :off
  end
  def instruction(:invert, :off) do
    escape 27, "m"
  # after
  #   instruction :invert, :on
  end

  def instruction(:conceal, :on) do
    escape 8, "m"
  # after
  #   instruction :conceal, :off
  end
  def instruction(:conceal, :off) do
    escape 28, "m"
  # after
  #   instruction :conceal, :on
  end

  def instruction(:strikethrough, :on) do
    escape 9, "m"
  # after
  #   instruction :strikethrough, :off
  end
  def instruction(:strikethrough, :off) do
    escape 29, "m"
  # after
  #   instruction :strikethrough, :on
  end

####
# FONTS
##

  def instruction(:font, type) when type in 0..9 do
    escape type + 10, "m"
  end

####
# FORGROUND COLORS
##

  def instruction(:foreground, :black) do
    escape 30, "m"
  # after
  #   instruction :default, :foreground
  end

  def instruction(:foreground, :red) do
    escape 31, "m"
  # after
  #   instruction :default, :foreground
  end

  def instruction(:foreground, :green) do
    escape 32, "m"
  # after
  #   instruction :default, :foreground
  end

  def instruction(:foreground, :yellow) do
    escape 33, "m"
  # after
  #   instruction :default, :foreground
  end

  def instruction(:foreground, :blue) do
    escape 34, "m"
  # after
  #   instruction :default, :foreground
  end

  def instruction(:foreground, :magenta) do
    escape 35, "m"
  # after
  #   instruction :default, :foreground
  end

  def instruction(:foreground, :cyan) do
    escape 36, "m"
  # after
  #   instruction :default, :foreground
  end

  def instruction(:foreground, :white) do
    escape 37, "m"
  # after
  #   instruction :default, :foreground
  end

  def instruction(:foreground, {r, g, b}) when r in 0..255 and g in 0..255 and b in 0..255 do
    escape [38, r, g, b], "m"
  # after
  #   instruction :default, :foreground
  end

  def instruction(:foreground, num) when num in 0..255 do
    escape [38, num], "m"
  end

  def instruction(:foreground, :default) do
    escape 39, "m"
  end

  ####
  # BACKGROUND COLORS
  ##

  def instruction(:background, :black) do
    escape 40, "m"
  # after
  #   instruction :default, :background
  end

  def instruction(:background, :red) do
    escape 41, "m"
  # after
  #   instruction :default, :background
  end

  def instruction(:background, :green) do
    escape 42, "m"
  # after
  #   instruction :default, :background
  end

  def instruction(:background, :yellow) do
    escape 43, "m"
  # after
  #   instruction :default, :background
  end

  def instruction(:background, :blue) do
    escape 44, "m"
  # after
  #   instruction :default, :background
  end

  def instruction(:background, :magenta) do
    escape 45, "m"
  # after
  #   instruction :default, :background
  end

  def instruction(:background, :cyan) do
    escape 46, "m"
  # after
  #   instruction :default, :background
  end

  def instruction(:background, :white) do
    escape 47, "m"
  # after
  #   instruction :default, :background
  end

  def instruction(:background, {r, g, b}) when r in 0..255 and g in 0..255 and b in 0..255 do
    escape [48, r, g, b], "m"
  # after
  #   instruction :default, :background
  end

  def instruction(:background, num) when num in 0..255 do
    escape [48, num], "m"
  end

  def instruction(:background, :default) do
    escape 49, "m"
  end

  ####
  # PAGER
  ##

  def instruction(:pager, {:up, amount}) do
    escape amount, "S"
  # after
  #   instruction :scroll, :down, amount
  end

  def instruction(:pager, {:down, amount}) do
    escape amount, "T"
  # after
  #   instruction :scroll, :down, amount
  end

  ####
  # CURSOR
  ##

  def instruction(:cursor, :position) do
    escape 6, "n"
  end
  def instruction(:cursor, :hide) do
    escape "?", "25l"
  end
  def instruction(:cursor, :show) do
    escape "?", "25h"
  end
  def instruction(:cursor, :save) do
    escape "s"
  end
  def instruction(:cursor, :restore) do
    escape "u"
  end

  def instruction(:cursor, {_, 0}) do
    escape 0, "A"
  end
  def instruction(:cursor, {:up, amount}) when is_integer(amount) and amount > 0 do
    escape amount, "A"
  end
  def instruction(:cursor, {:up, amount}) when is_integer(amount) and amount < 0 do
    escape abs(amount), "B"
  end
  def instruction(:cursor, {:down, amount}) when is_integer(amount) and amount > 0 do
    escape amount, "B"
  end
  def instruction(:cursor, {:down, amount}) when is_integer(amount) and amount < 0 do
    escape abs(amount), "A"
  end
  def instruction(:cursor, {:right, amount}) when is_integer(amount) and amount > 0 do
    escape amount, "C"
  end
  def instruction(:cursor, {:right, amount}) when is_integer(amount) and amount < 0 do
    escape abs(amount), "D"
  end
  def instruction(:cursor, {:left, amount}) when is_integer(amount) and amount > 0 do
    escape amount, "D"
  end
  def instruction(:cursor, {:left, amount}) when is_integer(amount) and amount < 0 do
    escape abs(amount), "C"
  end

  def instruction(:cursor, {row, col}) when
  (
    (
      is_integer(row) and row > 0
    ) or row == nil
  ) and (
    (
      is_integer(col) and col > 0
    ) or col == nil
  ) do
    escape [row, col], "H"
  end

  def instruction(:cursor, {:erase, :screen, :end}) do
    escape 0, "J"
  end
  def instruction(:cursor, {:erase, :screen, :start}) do
    escape 1, "J"
  end
  def instruction(:cursor, {:erase, :screen, :all}) do
    escape 2, "J"
  end

  def instruction(:cursor, {:erase, :line, :end}) do
    escape 0, "K"
  end
  def instruction(:cursor, {:erase, :line, :start}) do
    escape 1, "K"
  end
  def instruction(:cursor, {:erase, :line, :all}) do
    escape 2, "K"
  end

end
