defmodule QueueTest do
  use ExUnit.Case
  doctest Queue

  test "greets the world" do
    queue = Queue.new

    assert [] == queue.items

    queue = Queue.enqueue(queue, 1)
    assert [1] == queue.items

    queue = Queue.enqueue(queue, 2)
    assert [2, 1] == queue.items

    queue = Queue.enqueue(queue, 3)
    assert [3, 2, 1] == queue.items

    {:ok, item, queue} = Queue.dequeue(queue)
    assert 1 == item
    assert [3, 2] == queue.items

    {:ok, item, queue} = Queue.dequeue(queue)
    assert 2 == item
    assert [3] == queue.items

    refute Queue.is_empty?(queue)

    {:ok, item, queue} = Queue.dequeue(queue)
    assert 3 == item
    assert [] == queue.items

    assert Queue.is_empty?(queue)

    assert {:error, "empty"} == Queue.dequeue(queue)
  end
end
