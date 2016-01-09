defmodule Poker.Notifier do
  require Logger

  def notify({time_taken, [name: name, url: url]}) do
    {time, unit} = cond do
      time_taken > 1_000_000 -> {time_taken / 1_000_000, "seconds"}
      time_taken > 1_000 -> {time_taken / 1_000, "milliseconds"}
      true -> {time_taken, "microseconds"}
    end

    Logger.info("#{name} took #{time} #{unit} (#{url})")
  end
end
