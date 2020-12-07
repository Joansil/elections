defmodule Candidate do

  defstruct [:id, :name, votes: nil]

  def new(id, name) do
    %Candidate{id: id, name: name}
  end

end
