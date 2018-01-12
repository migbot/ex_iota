defmodule Iota.Utils do
  
  @tryte_codepoints String.codepoints("9ABCDEFGHIJKLMNOPQRSTUVWXYZ")

  def is_trytes_of_length?(string, length) when is_binary(string) and is_integer(length) do
    ~r/^[9A-Z]{#{length}}$/
    |> Regex.match?(string)
  end
  def is_trytes_of_length(_, _), do: false

  def is_trytes?(string) when is_binary(string) do
    ~r/^[9A-Z]{0,}$/
    |> Regex.match?(string)
  end
  def is_trytes?(_), do: false

  def trytes_from_charlist(charlist) when is_list(charlist) do
    charlist
    |> Enum.map(&(tryte_from_codepoint/1))
    |> Enum.join("")
  end
  def trytes_from_charlist(_), do: ""

  def trytes_to_charlist(trytes) do
    case is_trytes?(trytes) do
      true ->
        for <<tryte::binary-2 <- trytes>>, do: tryte_to_codepoint(tryte)
      false ->
        []
    end
  end

  defp tryte_from_codepoint(codepoint) do
    first_value = rem(codepoint, 27)
    second_value = div(codepoint - first_value, 27)

    Enum.at(@tryte_codepoints, first_value) <>
      Enum.at(@tryte_codepoints, second_value)
  end

  defp tryte_to_codepoint(tryte) do
    [first | [second | _tail]] = String.codepoints(tryte)
    <<tryte_codepoint_index(first) + tryte_codepoint_index(second) * 27>>
  end

  defp tryte_codepoint_index(tryte_codepoint) do
    Enum.find_index(@tryte_codepoints, &(&1 == tryte_codepoint))
  end

  def valid_address?(address) when is_binary(address) do
    is_trytes_of_length?(address, 81)
  end
  def valid_address?(_), do: false
end