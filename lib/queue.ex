defmodule Queue do
  defstruct [:items]

  @doc """
  iex> IO.puts 100
  :ok

  iex> queue = Queue.new
  ...> queue = Queue.enqueue(queue, 1)
  ...> queue = Queue.enqueue(queue, 2)
  ...> queue.items
  [2, 1]
  """
  def new do
    %Queue{items: []}
  end

  def enqueue(%Queue{items: items}, item) do
    %Queue{items: [item | items]}
  end

  def dequeue(%Queue{items: []}) do
    {:error, "empty"}
  end

  def dequeue(%Queue{items: items}) do
    {head, tail} = Enum.split(items, -1)
    {:ok, List.first(tail), %Queue{items: head}}
  end

  def is_empty?(%Queue{items: []}) do
    true
  end

  def is_empty?(_) do
    false
  end
end
