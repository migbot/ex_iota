defmodule Iota.Api do

  @node_url Application.get_env(:iota, :node_url)

  @doc """
  Returns information about the node.

  ## Examples

    iex> {:ok, status_code, data} = Iota.Api.get_node_info()
    iex> status_code
    200
    iex> match?(%{
    ...> "appName" => _,
    ...> "appVersion" => _,
    ...> "duration" => _,
    ...> "jreAvailableProcessors" => _,
    ...> "jreFreeMemory" => _,
    ...> "jreMaxMemory" => _,
    ...> "jreTotalMemory" => _,
    ...> "jreVersion" => _,
    ...> "latestMilestone" => _,
    ...> "latestMilestoneIndex" => _,
    ...> "latestSolidSubtangleMilestone" => _,
    ...> "latestSolidSubtangleMilestoneIndex" => _,
    ...> "neighbors" => _,
    ...> "packetsQueueSize" => _,
    ...> "time" => _,
    ...> "tips" => _,
    ...> "transactionsToRequest" => _
    ...> }, data)
    true
  """
  def get_node_info() do
    %{command: "getNodeInfo"}
    |> send_command
  end

  # @doc """
  # Returns the set of neighbors connected to the node.

  # ## Examples
  
  #   iex> {:ok, status_code, data} = Iota.Api.get_neighbors()
  #   iex> status_code
  #   200
  #   iex> match?(%{
  #   ...> "duration" => _,
  #   ...> "neighbors" => [_|_]
  #   ...> }, data)
  #   true
  # """
  # def get_neighbors() do
  #   %{command: "getNeighbors"}
  #   |> send_command
  # end

  # @doc """
  # Adds a list of neighbors to the node.

  # ## Examples
  
  #   iex> {:ok, status_code, data} = Iota.Api.add_neighbors(["udp://localhost:14265"])
  #   iex> status_code
  #   200
  #   iex> match?(%{
  #   ...> "duration" => _,
  #   ...> "addedNeighbors" => _
  #   ...> }, data)
  #   true
  # """
  # def add_neighbors([_|_] = uris) do
  #   %{command: "addNeighbors", uris: uris}
  #   |> send_command
  # end

  # @doc """
  # Removes a list of neighbors from the node.

  # ## Examples
  
  #   iex> {:ok, status_code, data} = Iota.Api.remove_neighbors(["udp://localhost:14265"])
  #   iex> status_code
  #   200
  #   iex> match?(%{
  #   ...> "duration" => _,
  #   ...> "removedNeighbors" => _
  #   ...> }, data)
  #   true
  # """
  # def remove_neighbors([_|_] = uris) do
  #   %{command: "removeNeighbors", uris: uris}
  #   |> send_command
  # end

  @doc """
  Returns the list of tips.

  ## Examples
  
    iex> {:ok, status_code, data} = Iota.Api.get_tips()
    iex> status_code
    200
    iex> match?(%{
    ...> "duration" => _,
    ...> "hashes" => [_|_]
    ...> }, data)
    true
  """
  def get_tips() do
    %{command: "getTips"}
    |> send_command
  end

  @doc """
  Returns the transactions which match the specified input.

  ## Examples
  
    iex> {:ok, status_code, data} = Iota.Api.find_transactions(bundles: ["HLSLTL9NWSOPLHFCTGTXXCAFBSHYQKDBFIHJFARGAZOSWGGZKYVEOCDKUSTNSZKK9OKXKLNPX9JDASKLD"])
    iex> status_code
    200
    iex> match?(%{
    ...> "duration" => _,
    ...> "hashes" => [_|_]
    ...> }, data)
    true
  """
  def find_transactions(options \\ []) when is_list(options) do
    valid_options = [:bundles, :addresses, :tags, :approvees]

    valid_options
    |> Enum.any?(&(Keyword.has_key?(options, &1)))
    |> case do
      true -> do_find_transactions(options)
      false -> {:error, "Valid options are #{inspect(valid_options)}"}
    end
  end
  defp do_find_transactions(options) do
    [command: "findTransactions"]
    |> Enum.concat(options)
    |> Enum.into(%{})
    |> send_command
  end

  @doc """
  Returns the raw transaction data (trytes) of a specific transaction.

  ## Examples

    iex> {:ok, status_code, data} = Iota.Api.get_trytes(["HLSLTL9NWSOPLHFCTGTXXCAFBSHYQKDBFIHJFARGAZOSWGGZKYVEOCDKUSTNSZKK9OKXKLNPX9JDASKLD"])
    iex> status_code
    200
    iex> match?(%{
    ...> "duration" => _,
    ...> "trytes" => [_|_]
    ...> }, data)
    true
  """
  def get_trytes([_|_] = hashes) do
    %{command: "getTrytes", hashes: hashes}
    |> send_command
  end


  @doc """
  Returns the inclusion states of a set of transactions.

  ## Examples

    iex> {:ok, status_code, data} = Iota.Api.get_inclusion_states(
    ...> ["UYWGMMRJBVQBZAJCGOKSRGCNDNRXIFEJMGHPPSTVJCEVEDBFHJVOTEYZGPDBUINWHQWXYRJMCYIJZ9999"],
    ...> ["XRHXPJAQVFAYSHDLRU9NVCDSSGJBWTNQKBPYRKTWYEESFTRREYOCIQQEGUYUPUHZERQVGYFANFSTZ9999"]
    ...> )
    iex> status_code
    200
    iex> match?(%{
    ...> "duration" => _,
    ...> "states" => [_|_]
    ...> }, data)
    true
  """
  def get_inclusion_states([_|_] = transactions, [_|_] = tips) do
    %{command: "getInclusionStates", transactions: transactions, tips: tips}
    |> send_command
  end

  @doc """
  Returns the confirmed balance which a list of addresses have at the latest confirmed milestone.

  ## Examples
    
    iex> {:ok, status_code, data} = Iota.Api.get_balances(
    ...> ["QRQPSSGXTKRMRRKKVECSRWG9ZZQVAMVSKWJXTBXMWWIDUX9YHXQKXADOOKMHCDHYDCYKOBQYLAB9QBUEW"],
    ...> 100
    ...> )
    iex> status_code
    200
    iex> match?(%{
    ...> "duration" => _,
    ...> "balances" => _,
    ...> "references" => _,
    ...> "milestoneIndex" => _
    ...> }, data)
    true
  """
  def get_balances([_|_] = addresses, threshold \\ 100) when is_integer(threshold) do
    %{command: "getBalances", addresses: addresses, threshold: threshold}
    |> send_command
  end

  @doc """
  Tip selection which returns `trunkTransaction` and `branchTransaction`.

  ## Examples

    iex> {:ok, status_code, data} = Iota.Api.get_transactions_to_approve(27)
    iex> status_code
    200
    iex> match?(%{
    ...> "duration" => _,
    ...> "trunkTransaction" => _,
    ...> "branchTransaction" => _
    ...> }, data)
    true
  """
  def get_transactions_to_approve(depth) when is_integer(depth) do
    %{command: "getTransactionsToApprove", depth: depth}
    |> send_command
  end

  def attach_to_tangle(trunk_transaction,
                     branch_transaction,
                     min_weight_magnitude,
                     trytes)
  do
    %{
      command: "attachToTangle",
      trunkTranksaction: trunk_transaction,
      branchTransaction: branch_transaction,
      minWeightMagnitude: min_weight_magnitude,
      trytes: trytes
    }
    |> send_command
  end

  def interrupt_attaching_to_tangle() do
    %{command: "interruptAttachingToTangle"}
    |> send_command
  end

  def broadcast_transactions(trytes) do
    %{command: "broadcastTransactions", trytes: trytes}
    |> send_command
  end

  def store_transactions(trytes) do
    %{command: "storeTransactions", trytes: trytes}
    |> send_command
  end

  defp send_command(data) do
    headers = [
      {"Content-Type", "application/json"},
      {"X-IOTA-API-Version", "1"}
    ]

    HTTPoison.post(@node_url, Poison.encode!(data), headers, timeout: :infinity)
    |> parse_response
  end

  defp parse_response({:error, error}), do: {:error, error}
  defp parse_response({:ok, %{body: body} = response}) when is_binary(body) do
    parse_response({:ok, %{response | body: Poison.decode!(body)}})
  end
  defp parse_response({:ok, %{status_code: 200 = status_code, body: body}}), do: {:ok, status_code, body}
  defp parse_response({:ok, %{status_code: status_code, body: body}}), do: {:error, status_code, body}
end