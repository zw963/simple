defmodule Queue do
  defstruct [:items]

  def new do
    %Queue{items: []}
  end

  def enqueue(queue, item) do
    %Queue{items: [item | queue.items]}
  end

  def dequeue(queue) do
    case queue do
      [] -> {:error, "empty"}
      _ ->
        {head, tail} = Enum.split(queue.items, -1)
        {:ok, List.first(tail), %Queue{items: head}}
    end
  end

  def is_empty?(queue) do
    queue.items == []
  end
end
