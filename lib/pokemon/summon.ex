defmodule Pokemon.Summon do
  use GenServer
  alias Pokemon.Pokedex

  #client
  def start_link(pokemon),
    do: GenServer.start_link(__MODULE__, pokemon, name: :summon)

  def summon(%Pokemon{name: name} = pkm, pid \\ :summon) do
    IO.puts("#{name} is summoned!")
    GenServer.cast(pid, {:summon, pkm})
  end

  def attack(num, pid \\ :summon) do
    %Pokemon{name: name, abilities: abilities} = GenServer.call(pid, :info)
    ability =
      abilities
      |> Enum.at(num)
    IO.puts("#{name} uses: #{ability}")
  end

  def info(pid \\ :summon),
    do: GenServer.call(pid, :info)

  def evolve(pid \\ :summon) do
    GenServer.cast(pid, :evolve)
  end

  #server
  def init(pokemon) do
    # IO.puts("#{name} summoned!")
    {:ok, pokemon}
  end

  def handle_call(:info, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:summon, el}, _state) do
    {:noreply, el}
  end

  def handle_cast(:evolve, state = %Pokemon{id: id, name: name}) do
    new = Pokedex.evolution_of(id)
    IO.puts("#{name} is evolving into #{new.name}")
    Pokemon.replace(state, new, :pokemon)
    {:noreply, new}
  end

end
