defmodule Iota.Utils do
  
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

  def valid_address?(address) when is_binary(address) do
    is_trytes_of_length?(address, 81)
  end
  def valid_address?(_), do: false
end