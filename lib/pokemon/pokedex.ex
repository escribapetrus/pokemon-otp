defmodule Pokemon.Pokedex do
  import HTTPoison, only: [get: 1]

  @api "https://pokeapi.co/api/v2/pokemon/"

  def search(id) when is_integer(id) do
    id |> to_string() |> search()
  end
  def search(name) do
    {:ok, %HTTPoison.Response{body: body}} = get(@api <> name)
    {:ok, %{"id" => id, "abilities" => abilities, "name" => name, "types" => types}} = Jason.decode(body)
    abilities = Enum.map(abilities, fn x -> x["ability"]["name"] end)
    types = Enum.map(types, fn x -> x["type"]["name"] end)
    %Pokemon{id: id, abilities: abilities, name: name, types: types}
  end

  def evolution_of(id) when is_integer(id) do
    id |> to_string() |> evolution_of()
  end
  def evolution_of(name) do
    {:ok, %HTTPoison.Response{body: body}} = get(@api <> name)
    {:ok, %{"species" => %{"url" => url}}} = Jason.decode(body)

    {:ok, %HTTPoison.Response{body: body}} = get(url)
    {:ok, %{"evolution_chain" => %{"url" => url}}} = Jason.decode(body)

    {:ok, %HTTPoison.Response{body: body}} = get(url)
    {:ok, %{"chain" => %{"evolves_to" => evolutions}}} = Jason.decode(body)

    %{"species" => %{"name" => evolution}} = evolutions |> Enum.at(0)
    search(evolution)
  end

end
