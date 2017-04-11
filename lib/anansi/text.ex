defmodule Anansi.Text do
  @moduledoc """
  ANSI escape codes that format, color, and change the font of terminal text.
  """

  import Anansi, only: [instruction: 2]

  @doc """
  Resets text formatting, font, and color.
  """
  def reset do
    instruction :text, :reset
  end

  @doc """
  Convenience function to insert io data into a sequence via `Anansi.Sequence.compose/1`.
  """
  def write(text), do: [text]

  @simple_formats ~w[
    bold
    faint
    italic
    underline
    invert
    conceal
    strikethrough
  ]a

  @format_states ~w[
    on
    off
  ]a

  @doc """
  Activates text to display with given `format`.

  Supported formats: `#{(@simple_formats ++ [:reveal, :blink]) |> Enum.map(&inspect/1) |> Enum.join("`, `")}`.

  The `:blink` format is set to `:slow` rather than `:fast`, this can be controlled via `format/2`.

  Alternatively, the `format` can be a keyword list of formats and states to use via `format/2`.
  """
  def format(format)

  def format(format) when format in unquote(@simple_formats), do: format format, :on

  # Pseudo formats

  def format(:reveal), do: format :reveal, :on
  def format(:blink),  do: format :blink,  :on

  def format(instructions) when is_map(instructions), do: instructions |> Map.to_list |> format
  def format(instructions) when is_list(instructions) do
    Enum.map(instructions, fn
      {format, state} -> format format, state
      format          -> format format
    end)
  end

  @doc """
  Sets `format` format to `state` `:on` or `:off`.

  Supported formats: `#{(@simple_formats ++ [:reveal, :blink]) |> Enum.map(&inspect/1) |> Enum.join("`, `")}`.

  You can also use the `:blink` format with ':slow' or ':fast'; `:on` corresponds to `:slow`.
  """
  def format(format, state) when format in @simple_formats and state in @format_states do
    instruction format, state
  end

  # Pseudo formats

  def format(:reveal, :on),  do: format :conceal, :off
  def format(:reveal, :off), do: format :conceal, :on

  def format(:blink, :on),   do: format :blink, :slow

  def format(:blink, :slow), do: instruction :blink, :slow
  def format(:blink, :fast), do: instruction :blink, :fast
  def format(:blink, :off),  do: instruction :blink, :off

  # Auto-generated format functions

  (@simple_formats ++ [:reveal]) |> Enum.each(fn format ->
    @doc """
    Sets `#{format}` format to `state` `:on` or `:off`.
    """
    def unquote(format)(state \\ :on)
    def unquote(format)(state), do: format unquote(format), state
  end)

  @blink_states ~w[
    slow
    fast
    off
  ]a

  @doc """
  Sets `:blink` format to `state` `:on` or `:off`.

  Supported states: `#{([:on] ++ @blink_states) |> Enum.map(&inspect/1) |> Enum.join("`, `")}`.

  The default `:on` state is equivalent to `:slow` to keep parity with other format functions.
  """
  def blink(state \\ :on)
  def blink(:on), do: blink :slow
  def blink(state) when state in @blink_states do
    instruction :blink, state
  end

  @font_types 0..9

  @doc """
  Sets the text font to an alternate `font` if available.

  Supported fonts are in the range `0..9` where `0` is the default font and `1..9`
  correspond to the available alternate fonts.

  The `:default` `type` is equivalent to font type `0`.
  """
  def font(font)
  def font(:default), do: font 0
  def font(font) when font in @font_types do
    instruction :font, font
  end

  @colors ~w[
    black
    red
    green
    yellow
    blue
    magenta
    cyan
    white
    default
  ]a

  @color_contexts ~w[
    foreground
    background
  ]a

  @doc """
  Sets the foreground text color to `color`.

  Supported colors: `#{@colors |> Enum.map(&inspect/1) |> Enum.join("`, `")}`.

  See `color/2` to set the background instead.

  You can also set the color to a specific value in the range `0..256` or to an
  `{r, g, b}` tuple where each element is also in the range `0..256`.

  Alternatively, the `color` can be a keyword list to set both foreground and background in one go via `color/2`.
  """
  def color(color)

  def color(color) when color in @colors, do: color color, :foreground

  def color(instructions) when is_map(instructions), do: instructions |> Map.to_list |> color
  def color(instructions) when is_list(instructions) do
    Enum.map(instructions, fn
      {type, name} -> color name, type
      name         -> color name
    end)
  end

  @doc """
  Sets the text color to `color` where `context` is `:foreground` or `:background`.

  Supported colors: `#{@colors |> Enum.map(&inspect/1) |> Enum.join("`, `")}`.

  You can also set the color to a specific value in the range `0..256` or to an
  `{r, g, b}` tuple where each element is in the range `0..256`.
 """
  def color(color, context)

  def color(color, context) when (
    color in @colors
    or color in 0..255
    or (
      is_tuple color
      and tuple_size(color) == 3
      and elem(color, 0) in 0..255 and elem(color, 1) in 0..255 and elem(color, 2) in 0..255
    )
  ) and context in @color_contexts do
    instruction context, color
  end

  # Auto-generated color functions

  (@colors -- [:default]) |> Enum.each(fn color ->
    @doc """
    Sets the text color to `#{inspect color}` where `context` is `:foreground` or `:background`.
    """
    def unquote(color)(context \\ :foreground)
    def unquote(color)(context) when context in @color_contexts, do: color unquote(color), context
  end)

end
