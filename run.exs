{:ok, game} = Pokemon.start_link()

add = ~w{abra pikachu mew lapras squirtle}
add = add |> Enum.map(&Pokemon.Pokedex.search(&1))
add |> Enum.each(fn x -> Pokemon.add(game, x) end)
