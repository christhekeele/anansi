defmodule Anansi.Screen do
  @moduledoc """
  ANSI escape sequences that manipulate the terminal screen.
  """

  import Anansi.Sequence, only: [compose: 1]

  @doc """
  Clears entire screen.
  """
  def clear do
    Anansi.Cursor.erase :screen
  end

  # def size!(device \\ :stdio) do
  #   IO.write device, compose(cursor: [:save, {:position, {999999999, 999999999}}])
  #   {row, col} = Anansi.Cursor.position!(device)
  #   IO.write device, compose(cursor: :restore)
  #   {row, col}
  # end

end
