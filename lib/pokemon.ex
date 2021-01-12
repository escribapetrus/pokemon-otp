defmodule Pokemon do
  use GenServer
  alias Pokemon.Summon

  defstruct [:id, :name, :types, :abilities]

  #client
  def start_link(opts \\ []),
    do: GenServer.start_link(__MODULE__, opts, name: :pokemon)

  def list(pid \\ :pokemon),
    do: GenServer.call(pid, :list)

  def add(el, pid \\ :pokemon),
    do: GenServer.cast(pid, {:push, el})

  def replace(from, to, pid \\ :pokemon),
    do: GenServer.cast(pid, {:update, from, to})

  def summon(num, pid \\ :pokemon) do
    pokemon =
      GenServer.call(pid, :list)
      |> Enum.at(num)
    Summon.summon(pokemon)
  end

  #server
  def init(opts) do
    {:ok, opts}
  end

  def handle_call(:list, _from, state),
    do: {:reply, state, state}

  def handle_cast({:push, el}, state),
    do: {:noreply, [el | state]}

  def handle_cast({:update, from, to}, state) do
    idx = state |> Enum.find_index(fn x -> x == from end)
    state = List.replace_at(state, idx, to)
    {:noreply, state}
  end
end
