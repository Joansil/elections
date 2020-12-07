defmodule ElectionTest do
  use ExUnit.Case


  setup do
  %{election: %Election{}}
  end

  test "updating a election name from the command (n)", cx do
    cmd = "n Prefeitura Juazeiro of North"
    election = Election.update_election(cx.election, cmd)
    assert election == %Election{name: "Prefeitura Juazeiro of North"}
  end

  test "adding a new candidate from the command (a)", cx do
    cmd = "a Chico Pankika"
    election = Election.update_election(cx.election, cmd)
    assert election == %Election{
      candidates: [
        %Candidate{id: 1, name: "Chico Pankika", votes: nil},
        %Candidate{id: nil, name: " ", votes: nil}
      ],
      name: " ",
      next_id: 2
    }
  end

  test "votting for a candidate from the command (v)", cx do
    cmd = "v 1"
    election = Election.update_election(cx.election, cmd)
    assert election == %Election{candidates: [%Candidate{id: 1, name: "Chico Pankika", votes: 1},
    %Candidate{id: nil, name: " ", votes: nil}
      ],
      name: " ",
      next_id: 2
    }
  end

end
