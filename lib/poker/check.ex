defmodule Poker.Check do
  @spec check(Poker.Pokee.t) :: {number, Poker.Pokee.t}
  @doc """
  Requests a page and reports the time taken in microseconds, as well as
  the Pokee specification in a tuple.
  """
  def check(pokee = [name: _name, url: url]) do
    {time_taken, _} = :timer.tc(fn -> make_request(url) end)

    {time_taken, pokee}
  end

  defp header_map(headers) do
    Enum.into(headers, %{},
      fn {header, value} ->
        {List.to_string(header), List.to_string(value)}
      end)
  end

  defp make_request(url), do: make_request(url, 10_000)

  defp make_request(url, timeout) when is_list(url) do
    {:ok, resp} = :lhttpc.request(url,
                                  :get,
                                  [],
                                  timeout)
    {{code_num, _code_string}, headers, body} = resp

    case code_num do
      301 ->
        %{"location" => location} = header_map(headers)
        make_request(location, timeout)
      200 -> body
      _ -> :error
    end
  end

  defp make_request(url, timeout) when is_binary(url) do
    {:ok, resp} = :lhttpc.request(String.to_char_list(url),
                                  :get,
                                  [],
                                  timeout)
    {{code_num, _code_string}, headers, body} = resp

    case code_num do
      301 ->
        %{"location" => location} = header_map(headers)
        make_request(location, timeout)
      200 -> body
      _ -> {{:error, "unknown response code"}}
    end
  end

  defp start_poke_task(pokee) do
    {:ok, _pid} = Task.start(fn -> Poker.Notifier.notify(check(pokee)) end)
    :ok
  end

  def check_several(pokees \\ Application.get_env(:poker, :pokees)) do
    Enum.each(pokees, &start_poke_task/1)
  end
end
