defmodule Anansi.Cursor do
  @moduledoc """
  ANSI escape codes that manipulate the terminal cursor.

  ANSI treats the cursor co-ordinates as positive integers of format `{row in 1..∞, col in 1..∞}`.

  It will ignore requests to move the cursor beyond the bounds of the terminal window.
  """

  import Anansi, only: [instruction: 2]
  # import Anansi.Sequence, only: [compose: 1]

  @doc """
  Moves cursor to top-left corner of screen (`{1, 1}`).
  """
  def home do
    move :pos, {1, 1}
  end

  @doc """
  Hides the cursor.
  """
  def hide do
    instruction :cursor, :hide
  end

  @doc """
  Shows the cursor.
  """
  def show do
    instruction :cursor, :show
  end

  @doc """
  Saves the cursor position.
  """
  def save do
    instruction :cursor, :save
  end

  @doc """
  Moves the cursor to saved position.
  """
  def restore do
    instruction :cursor, :restore
  end

  @directions ~w[
    up
    down
    right
    left
  ]a

  @direction_aliases [
    right: [:forward, :forwards, :next],
    left:  [:backward, :backwards, :back, :prev],
  ]

  @doc """
  Moves cursor forwards.
  """
  def move do
    move :forwards
  end

  @doc """
  Moves cursor in `direction`.

  Allowed directions: `:up`, `:down`, `:right`, or `:left`.

  The `:right` direction is aliased as `:forward`, `:forwards`, and `:next`.

  The `:left` direction is aliased as `:backward`, `:backwards`, `:back`, and `:prev`.

  Alternatively, the `direction` can be a keyword list of directions and amounts to move via `move/2`.
  """
  def move(direction)

  @directions |> Enum.each(fn direction ->
    def move(unquote(direction)), do: instruction :cursor, unquote(direction)
  end)

  @direction_aliases |> Keyword.values |> Enum.each(fn aliases ->
    Enum.each(aliases, fn alias ->
      def move(unquote(alias)), do: move unquote(alias)
    end)
  end)

  def move(instructions) when is_map(instructions), do: instructions |> Map.to_list |> move
  def move(instructions) when is_list(instructions) do
    Enum.map(instructions, fn
      {direction, count} -> move direction, count
      direction          -> move direction
    end)
  end

  @doc """
  Moves cursor in `direction` by `amount`.

  Allowed directions: `:up`, `:down`, `:right`, or `:left`.

  The `:right` direction is aliased as `:forward`, `:forwards`, and `:next`.

  The `:left` direction is aliased as `:backward`, `:backwards`, `:back`, and `:prev`.

  Additionally, the `:pos` direction will move to a supplied `{row, col}` location,
  and the `:row` and `:col` directions will set that co-ordinate to `amount` and
  the other to `1`.
  """
  def move(direction, amount)

  @directions |> Enum.each(fn direction ->
    def move(unquote(direction), amount) when is_integer(amount) do
      instruction :cursor, {unquote(direction), amount}
    end
  end)

  @direction_aliases |> Enum.each(fn {direction, aliases} ->
    Enum.each(aliases, fn alias ->
      def move(unquote(alias), amount), do: move unquote(direction), amount
    end)
  end)

  def move(:row, row), do: move :pos, {row, 1}
  def move(:col, col), do: move :pos, {1, col}
  def move(:pos, {row, col}) when
    is_integer(row) and row > 0
    and is_integer(col) and col > 0
  do
    instruction :cursor, {row, col}
  end

  def move(:to, location), do: move location

  # Auto-generated movement functions

  @directions |> Enum.each(fn direction ->
    @doc """
    Moves cursor #{direction}.
    """
    def unquote(direction)(), do: move unquote(direction)
    @doc """
    Moves cursor #{direction} by `amount`.
    """
    def unquote(direction)(amount), do: move unquote(direction), amount
  end)

  @direction_aliases |> Enum.each(fn {direction, aliases} ->
    Enum.each(aliases, fn alias ->
      @doc """
      Moves cursor #{direction}.
      """
      def unquote(alias)(), do: move unquote(direction)
      @doc """
      Moves cursor #{direction} by `amount`.
      """
      def unquote(alias)(amount), do: move unquote(direction), amount
    end)
  end)

  @doc """
  Move cursor to `row` of the current column.
  """
  def row(row) do
    instruction :cursor, {row, nil}
  end

  @doc """
  Move cursor to `col` of the current row.
  """
  def col(col) do
    instruction :cursor, {nil, col}
  end

  @doc """
  Asks the terminal to report the current cursor position.

  Terminal will insert `"\\e[n;mR"` into the input device where `n` is the row and `m` the column.
  """
  def position do
    instruction :cursor, :position
  end

  @doc """
  Move cursor to position `{row, col}.`
  """
  def position({row, col}), do: move :pos, {row, col}

  # @doc """
  # Extracts the current cursor position from the terminal.
  #
  # Sends the `position/0` instruction, parses the result, and clears the result from the terminal.
  # """
  # def position!(device \\ :stdio) do
  #   IO.write device, compose(cursor: [:save, :position])
  #   result = IO.read device, :line
  #   %{"row" => row, "col" => col} = Regex.named_captures(~r/(?<row>\d+);(?<col>\d+)R/, result)
  #   IO.write device, compose(cursor: :restore, text: [write: String.pad_leading("", String.length(result))], cursor: :restore)
  #   {String.to_integer(row), String.to_integer(col)}
  # end

  @erasure_things ~w[
    screen
    line
  ]a

  @erasure_ways ~w[
    end
    start
    all
  ]a

  @doc """
  Erases entire `thing` around cursor.

  Supported things: `#{@erasure_things |> Enum.map(&inspect/1) |> Enum.join("`, `")}`.

  Additionally, the `thing` can be a keyword list of things and ways to erase via `erase/2`.
  """
  def erase(thing)
  def erase(thing) when thing in @erasure_things, do: erase thing, :all

  def erase(instructions) when is_map(instructions), do: instructions |> Map.to_list |> erase
  def erase(instructions) do
    Enum.map(instructions, fn
      {thing, type} -> erase thing, type
      thing         -> erase thing
    end)
  end

  @doc """
  Erases `thing` around the cursor in the specified `way`.

  You can erase `:all` around the cursor, or just erase to `:start` or `:end` of `thing`.

  Supported things: `#{@erasure_things |> Enum.map(&inspect/1) |> Enum.join("`, `")}`.
  """
  def erase(thing, way)

  def erase(thing, way) when thing in @erasure_things and way in @erasure_ways do
    instruction :cursor, {:erase, thing, way}
  end

end
