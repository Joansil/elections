defmodule Election do

  defstruct(
    name: " ",
    candidates: [
      Candidate.new(nil, " ")
    ],
    next_id: 1
  )

  def run() do
    %Election{} |> run()
  end

  def run(election = %Election{}) do
    [IO.ANSI.clear(), IO.ANSI.cursor(0, 0)]
    |> IO.write()

    election
      |> view()
      |> IO.write()

    commands = IO.gets("->")

    election
      |> update_election(commands)
      |> run()
  end

  def run(:obrigado_por_votar!), do: :obrigado_por_votar!

  def view_header(election) do
    [
      "Eleições para: #{election.name}\n"
    ]
  end

  def view_body(election) do
    election.candidates
      |> candidates_by_votes()
      |> candidates_list()
      |> candidates_list_header()
  end

  defp candidates_by_votes(candidates) do
    candidates
    |> Enum.sort(&(&1.votes >= &2.votes))
  end

  defp candidates_list(candidates) do
    candidates
    |> Enum.map(fn %{id: id, name: name, votes: votes} ->
      "#{id}\t#{name}\t\t#{votes}\n"
    end)
  end

  defp candidates_list_header(candidates) do
    [
      "Número\tCandidato\tVotos\n",
       "----------------------------\n"

       | candidates
    ]
  end

  def view_commands() do
    [
      "\n",
    "comandos: (n)ome <nome da eleição>, (a)dicionar <nome do candidato>, (v)otar <número do candidato>, (s)air\n"
    ]
  end

  def view(election) do
    [
      view_header(election),
      view_body(election),
      view_commands()
    ]
  end

  def update_election(election, ["n" <> _var | args]) do
    name = Enum.join(args, " ")
    Map.put(election, :name, name)
  end

  def update_election(election, ["a" <> _var | args]) do
    name = Enum.join(args, " ")

    candidate = Candidate.new(election.next_id, name)
    candidate = [candidate | election.candidates]

    election
      |> Map.put(:candidates, candidate)
      |> Map.put(:next_id, election.next_id + 1)

  end

  def update_election(election, cmd) when is_binary(cmd) do
    update_election(election, String.split(cmd))
  end

  def update_election(election, ["v" <> _var, id]) do
    vote(election, Integer.parse(id))
  end

  def update_election(_election, ["s" <> _var]), do: :obrigado_por_votar!

  defp vote(election, {id, ""}) do
    candidates = Enum.map(election.candidates, &count_vote(&1, id))
    Map.put(election, :candidates, candidates)
  end

  defp vote(election, _error), do: election

  defp count_vote(candidate, id) when is_integer(id) do
    count_vote(candidate, candidate.id == id)
  end

  defp count_vote(candidate, _inc = true) do
    Map.update!(candidate, :votes, &(&1 + 1))
  end

  defp count_vote(candidate, _inc = false), do: candidate

end
