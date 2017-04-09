defmodule Anansi.Sequence do
  @moduledoc """
  Tools for generating escape codes for multiple ANSI instructions in one go.
  """

  @doc """
  Macro for generating multiple ANSI escape instructions in one go.
  """
  defmacro compose(sequence, block \\ []) do
    sequence = List.wrap sequence
    {code, sequence} = Keyword.pop(sequence, :do, Keyword.get(block, :do, []))
    quote do: [
      [unquote(sequence) |> Anansi.Sequence.build |> Enum.map(fn {m, f, a} -> apply(m, f, a) end)],
      [unquote(code)],
      # run(reverse(unquote(sequence))),
      # [unquote(Keyword.get(block, :after, []))],
    ]
  end

  @doc """
  Macro for generating multiple self-closing ANSI escape sequences in one go.
  """
  defmacro execute(sequence, block \\ []) do
    {code, sequence} = Keyword.pop(sequence, :do, Keyword.get(block, :do, []))
    quote do: [
      [unquote(sequence) |> Anansi.Sequence.build |> Enum.map(fn {m, f, a} -> apply(m, f, a) end)],
      [unquote(code)],
      # run(reverse(unquote(sequence))),
      # [unquote(Keyword.get(block, :after, []))],
    ]
  end

  def build(sequence) do
    sequence |> explode |> Enum.map(&prepare/1)
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

  defp prepare([arg | [fun | [namespace | []]]]) do
    do_prepare([namespace], fun, [arg])
  end

  defp prepare([fun | [namespace | []]]) do
    do_prepare([namespace], fun)
  end

  defp prepare([fun | []]) do
    do_prepare([], fun)
  end

  defp prepare(other) do
    raise "unrecognized Anansi sequence: `#{inspect(:lists.reverse(other))}`"
  end

  defp do_prepare(namespace, fun, args \\ []) do
    module = namespace
      |> Enum.map(&(&1 |> to_string |> Macro.camelize))
      |> :lists.reverse
      |> Enum.reduce(Anansi, &(Module.concat &2, &1))
    {module, fun, args}
  end

end
