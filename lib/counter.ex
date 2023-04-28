defmodule Counter do
  use GenServer

  def start_link(args) do
    initial_count = Keyword.get(args, :initial_count, 0)
    name = Keyword.get(args, :name)
    GenServer.start_link(__MODULE__, initial_count, name: name)
  end

  def increment(pid) do
    GenServer.call(pid, :inc)
  end

  def decrement(pid) do
  GenServer.call(pid, :dec)
  end

  def current(pid) do
    GenServer.call(pid, :current)
  end



  def init(initial_count) do
    {:registered_name, name} = Process.info(self(), :registered_name)
    initial_count =
      case Cache.lookup(name) do
        {:ok, count} -> count
        :error -> initial_count
      end
     {:ok, initial_count}
  end

  def handle_call(:inc, _from, count) do
    updated_count = count + 1
    {:reply, updated_count, updated_count}
  end

  def handle_call(:dec, _from, count) do
    updated_count = count - 1
    {:reply, updated_count, updated_count}
  end

  def handle_call(:current, _from, count) do
    {:reply, count, count}
  end

  def terminate(_reason, count) do
    {:registered_name, name} = Process.info(self(), :registered_name)
    Cache.save(name, count)
  end
end
