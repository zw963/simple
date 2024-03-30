defmodule Simple do
end

defmodule MyList do
  # 这里额外写一个一个参数的方法, 作为入口, 来调用下面的尾递归.
  def sum(list) do
    sum(list, 0)
  end

  # 建议这里的私有函数改名为 _sum,
  defp sum([], total) do
    total
  end

  defp sum([head | tail], total) do
    sum(tail, total + head)
  end
end

defmodule MyList1 do
  def sum([]) do
    0
  end

  def sum([head | tail]) do
    head + sum(tail)
  end
end
