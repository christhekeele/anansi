defmodule Anansi.Sequence do
  @moduledoc """
  Tools for generating escape codes for multiple ANSI instructions in one go.
  """

  # @doc """
  # Macro for generating multiple ANSI escape instructions in one go.
  # """
  # defmacro compose(sequence, block \\ []) do
  #   sequence = List.wrap sequence
  #   {code, sequence} = Keyword.pop(sequence, :do, Keyword.get(block, :do, [""]))
  #   quote do: [
  #     [unquote(sequence) |> Anansi.Sequence.compose],
  #     [unquote(code)],
  #     # revert somehow
  #   ]
  # end

  @doc """
  Composes multiple ANSI escape instructions from a `sequence` of instructions.
  """
  def compose(sequence) when is_list(sequence) do
    sequence |> build |> Enum.map(fn {m, f, a} -> apply(m, f, a) end)
  end

  @doc """
  Converts an Anansi `sequence` of instructions into `{module, function, args}` tuples.
  """
  def build(sequence) when is_list(sequence) do
    sequence |> explode |> Enum.map(&instruction/1)
  end

  defp explode(tree) do
    :lists.reverse(do_explode(tree, [], []))
  end

  defp do_explode([], _, acc) do
    acc
  end

  defp do_explode([{key, subtree} | trees], current, acc) do
    do_explode(trees, current, do_explode(subtree, [key | current], acc))
  end

  defp do_explode([key | rest], current, acc) do
    do_explode(rest, current, do_explode(key, current, acc))
  end

  defp do_explode(leaf, current, acc) do
    [[leaf | current] | acc]
  end

  defp instruction([arg | [fun | [namespace | []]]]) do
    do_instruction([namespace], fun, [arg])
  end

  defp instruction([fun | [namespace | []]]) do
    do_instruction([namespace], fun)
  end

  defp instruction([fun | []]) do
    do_instruction([], fun)
  end

  defp instruction(other) do
    raise "unrecognized Anansi instruction: `#{inspect(:lists.reverse(other))}`"
  end

  defp do_instruction(namespace, fun, args \\ []) do
    module = namespace
      |> Enum.map(&(&1 |> to_string |> Macro.camelize))
      |> :lists.reverse
      |> Enum.reduce(Anansi, &(Module.concat &2, &1))
    {module, fun, args}
  end

end
