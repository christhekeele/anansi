defmodule Anansi.Pager do
  @moduledoc """
  ANSI escape sequences that manipulate the terminal pager.
  """

  import Anansi, only: [instruction: 2]

  @doc """
  Scrolls screen down 1 line.
  """
  def scroll, do: scroll :down

  @doc """
  Scrolls screen by `instruction`.

  If an integer is given, scrolls down by that amount. If direction `:up`/`:down`
  is given, scrolls in that direction by 1.

  Alternatively, the `instruction` can be a keyword list of directions and amounts to scroll via `scroll/2`.
  """
  def scroll(instruction)
  def scroll(amount)    when is_integer(amount), do: scroll :down, amount
  def scroll(direction) when is_atom(direction), do: scroll direction, 1

  def scroll(instructions) when is_map(instructions), do: instructions |> Map.to_list |> scroll
  def scroll(instructions) when is_list(instructions) do
    Enum.map(instructions, fn
      {direction, amount} -> scroll direction, amount
      direction           -> scroll direction
    end)
  end

  @doc """
  Scrolls screen `direction` by `amount`.
  """
  def scroll(direction, amount)
  def scroll(:up, amount) do
    instruction :pager, {:up, amount}
  end
  def scroll(:down, amount) do
    instruction :pager, {:down, amount}
  end

end
