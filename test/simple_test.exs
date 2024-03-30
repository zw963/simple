defmodule SimpleTest do
  use ExUnit.Case

  test "Enum module" do
    cart = [
      %{fruit: "apple", count: 3},
      %{fruit: "banana", count: 1},
      %{fruit: "orange", count: 6}
    ]

    pairs = [{"apple", 3}, {"banana", 1}, {"orange", 6}]

    a = ["apple", "banana", "orange"]

    b = [3, 1, 6]

    assert pairs == Enum.zip(a, b)

    # 先 zip , 再 reduce
    assert 10 ==
             Enum.zip_reduce(a, b, 0, fn _a, b, acc ->
               acc + b
             end)

    assert cart ==
             Enum.zip_with(a, b, fn a, b ->
               %{fruit: a, count: b}
             end)

    assert [
             %{fruit: "banana", count: 1},
             %{fruit: "orange", count: 6}
             # 从前往后 drop 的数量
           ] == Enum.drop(cart, 1)

    assert {a, b} == Enum.unzip(pairs)

    x = [1, 2, 3, 4, 5, 6]

    dbg(Enum.random(x))
    dbg(Enum.shuffle(x))
    dbg(Enum.take_random(x, 2))

    assert [[1, 2], [3, 4], [5, 6]] == Enum.chunk_every(x, 2)

    assert [
             ["apple"],
             ["banana", "orange"]
           ] == Enum.chunk_by(["apple", "banana", "orange"], &String.length/1)

    # 从后往前 drop 的数量
    assert [1, 2, 3, 4] == Enum.drop(x, -2)
    assert [5, 6] == Enum.take(x, -2)

    assert [2, 4, 6] == Enum.drop_every(x, 2)
    # 每隔 3 个, drop 一个(计数 nth 时, 包含被 drop 的那个), 第一个总是 drop
    assert [2, 3, 5, 6, 8, 9] == Enum.drop_every(1..10, 3)
    assert [1, 4, 7, 10] == Enum.take_every(1..10, 3)
    # take_while 是 take_every 的 fn  版本

    assert [
             %{fruit: "apple", count: 3},
             %{fruit: "banana", count: 1}
           ] == Enum.slice(cart, 0..1)

    assert [
             %{fruit: "banana", count: 1},
             %{fruit: "orange", count: 6}
           ] == Enum.slice(cart, -2..-1)

    assert {
             [
               %{fruit: "apple", count: 3}
             ],
             [
               %{fruit: "banana", count: 1},
               %{fruit: "orange", count: 6}
             ]
             # 使用索引号 split
           } == Enum.split(cart, 1)

    assert {
             [%{fruit: "apple", count: 3}],
             [
               %{fruit: "banana", count: 1},
               %{fruit: "orange", count: 6}
               # 为 true 时 split, 一旦为 false, 立即停止
             ]
           } == Enum.split_while(cart, &(&1.fruit =~ "e"))

    # 按照指定的策略 split

    assert {
             [
               %{fruit: "apple", count: 3},
               %{fruit: "orange", count: 6}
             ],
             [%{fruit: "banana", count: 1}]
           } == Enum.split_with(cart, &(&1.fruit =~ "e"))

    v = Enum.group_by(cart, &String.last(&1.fruit))

    # 开始的索引号, 以及返回元素的数量
    assert [2, 3] == Enum.slice([1, 2, 3, 4, 6, 7, 8], 1, 2)

    fruits = ["apple", "banana", "grape", "orange", "pear"]

    # 取出索引 2 元素, 插入 0
    assert ["grape", "apple", "banana", "orange", "pear"] == Enum.slide(fruits, 2, 0)

    # 取出 1..3 元素插入索引 0
    assert ["banana", "grape", "orange", "apple", "pear"] == Enum.slide(fruits, 1..3, 0)

    assert [3, 2, 1] == Enum.reverse([1, 2, 3])
    # 把参数作为 tail
    assert [3, 2, 1, 8, 9] == Enum.reverse([1, 2, 3], [8, 9])

    # 只 reverse 指定索引的元素
    assert [
             %{fruit: "apple", count: 3},
             %{fruit: "orange", count: 6},
             %{fruit: "banana", count: 1}
           ] == Enum.reverse_slice(cart, 1, 2)

    Enum.reverse_slice(cart, 1, 2)

    # 针对 value 也应用表达式
    v1 = Enum.group_by(cart, &String.last(&1.fruit), & &1.fruit)

    assert %{
             "a" => [%{fruit: "banana", count: 1}],
             "e" => [
               %{fruit: "apple", count: 3},
               %{fruit: "orange", count: 6}
             ]
           } == v

    assert %{
             "a" => ["banana"],
             "e" => ["apple", "orange"]
           } == v1

    assert %{fruit: "orange", count: 6} == Enum.find(cart, &(&1.fruit =~ "o"))
    # find_value 返回 block 的值
    assert true == Enum.find_value(cart, &(&1.fruit =~ "o"))
    assert 2 == Enum.find_index(cart, &(&1.fruit =~ "o"))

    assert :none == Enum.find(cart, :none, &(&1.fruit =~ "y"))
    assert nil == Enum.find(cart, &(&1.fruit =~ "y"))

    assert [
             {%{fruit: "apple", count: 3}, 0},
             {%{fruit: "banana", count: 1}, 1},
             {%{fruit: "orange", count: 6}, 2}
           ] == Enum.with_index(cart)

    assert [
             "apple",
             ", ",
             "banana",
             ", ",
             "orange"
           ] == Enum.intersperse(["apple", "banana", "orange"], ", ")

    Enum.dedup_by(cart, &(&1.fruit =~ "a"))

    assert [1, 2, 3, 1, 2, 3] == Enum.dedup([1, 2, 2, 3, 3, 3, 1, 2, 3])
    assert [1, 2, 3] == Enum.uniq([1, 2, 2, 3, 3, 3, 1, 2, 3])

    assert %{fruit: "apple", count: 3} == Enum.at(cart, 0)
    # 注意 Enum.at 和 tuple 的区分
    assert "apple" == elem({"apple", "banana", "orange"}, 0)

    assert "applebananaorange" == Enum.join(["apple", "banana", "orange"])
    assert "apple, banana, orange" == Enum.join(["apple", "banana", "orange"], ", ")

    # map 的结果再 join
    assert "apple, banana, orange" == Enum.map_join(cart, ", ", & &1.fruit)

    # pattern match use fetch instead
    assert {:ok, %{fruit: "apple", count: 3}} == Enum.fetch(cart, 0)

    assert [
             %{fruit: "apple", count: 3},
             %{fruit: "banana", count: 1}
           ] == Enum.uniq_by(cart, &String.last(&1.fruit))

    v = %{"apple" => 3, "banana" => 1, "orange" => 6}

    # 将 Enum 的元素, 插入一个 collectable , 这里是 %{}
    assert v == Enum.into(pairs, %{})

    assert v == Enum.into(cart, %{}, &{&1.fruit, &1.count})

    # 终于看到 to_a 等价方法了
    assert [1, 2, 3, 4, 5] == Enum.to_list(1..5)

    v =
      Enum.flat_map_reduce(cart, 0, fn item, acc ->
        list = List.duplicate(item.fruit, item.count)
        acc = acc + item.count
        {list, acc}
      end)

    # 为什么会提供这么复杂的东西
    # 返回一个 tuple, 第一个元素是 flat_map 的结果, 第二个元素是 reduce 结果
    result =
      {[
         "apple",
         "apple",
         "apple",
         "banana",
         "orange",
         "orange",
         "orange",
         "orange",
         "orange",
         "orange"
       ], 10}

    assert result == v

    v = List.duplicate("apple", 3)
    assert ["apple", "apple", "apple"] == v

    # 先 map, 然后 flatten
    v =
      Enum.flat_map(cart, fn item ->
        List.duplicate(item.fruit, item.count)
      end)

    assert [
             "apple",
             "apple",
             "apple",
             "banana",
             "orange",
             "orange",
             "orange",
             "orange",
             "orange",
             "orange"
           ] == v

    v = Enum.concat([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
    assert [1, 2, 3, 4, 5, 6, 7, 8, 9] == v
    assert [1, 2, 3, 4, 5, 6, 7, 8, 9] == [1, 2, 3] ++ [4, 5, 6] ++ [7, 8, 9]

    assert [1, 2, 3, 4, 5, 6] == Enum.concat([1, 2, 3], [4, 5, 6])

    v = cart |> Enum.map(& &1.fruit) |> Enum.sort()
    assert ["apple", "banana", "orange"] == v

    v = cart |> Enum.map(& &1.fruit) |> Enum.sort(:desc)
    assert ["orange", "banana", "apple"] == v

    assert 1 == cart |> Enum.map(& &1.count) |> Enum.min()
    assert %{fruit: "banana", count: 1} == Enum.min_by(cart, & &1.count)

    assert 6 == cart |> Enum.map(& &1.count) |> Enum.max()
    assert %{fruit: "orange", count: 6} == Enum.max_by(cart, & &1.count)

    assert 18 == cart |> Enum.map(& &1.count) |> Enum.product()

    v = Enum.frequencies(["apple", "banana", "orange", "apple"])

    assert %{"apple" => 2, "banana" => 1, "orange" => 1} == v

    v = Enum.frequencies_by(cart, &String.last(&1.fruit))
    assert %{"a" => 1, "e" => 2} == v

    assert 3 == Enum.count(cart)
    assert 2 == Enum.count(cart, fn item -> item.fruit =~ "e" end)
    # assert 10 = cart |> then(&Enum.sum(&1.count))
    assert 10 = cart |> Enum.map(& &1.count) |> Enum.sum()

    v =
      Enum.reduce_while(cart, 0, fn item, acc ->
        if item.fruit == "orange" do
          {:halt, acc}
        else
          {:cont, item.count + acc}
        end
      end)

    assert 4 == v

    # 类似于 reduce, 但是也返回中间结果,
    v =
      Enum.scan(cart, 0, fn item, acc ->
        item.count + acc
      end)

    assert [3, 4, 10] == v

    v =
      Enum.reduce(cart, 0, fn item, acc ->
        acc + item.count
      end)

    assert 10 == v

    # 看起来, 是对 item 执行 map, 同时, 也针对 acc 执行 reduce, 返回一个 tuple
    v =
      Enum.map_reduce(cart, 0, fn item, acc ->
        {item.fruit, item.count + acc}
      end)

    assert {["apple", "banana", "orange"], 10} == v

    assert ["apple", "banana", "orange"] == Enum.map(cart, & &1.fruit)

    v =
      for item <- cart, item.fruit =~ "e" do
        item.fruit
      end

    assert v == ["apple", "orange"]

    # 每隔两个, 选择一个元素 map 一次.
    v =
      Enum.map_every(cart, 2, fn item ->
        %{item | count: item.count + 10}
      end)

    assert v == [
             %{fruit: "apple", count: 13},
             %{fruit: "banana", count: 1},
             %{fruit: "orange", count: 16}
           ]

    v = Enum.each(cart, &IO.puts(&1.fruit))
    assert :ok == v

    assert true == Enum.any?(cart, &(&1.fruit == "orange"))
    assert false == Enum.any?(cart, &(&1.fruit == "pear"))

    assert false == Enum.any?([], &(&1.fruit == "orange"))

    assert true == Enum.all?(cart, &(&1.count > 0))
    assert false == Enum.all?(cart, &(&1.count > 1))
    assert true == Enum.all?([], &(&1.count > 10))

    assert true == Enum.member?(cart, %{fruit: "apple", count: 3})
    assert true == %{fruit: "apple", count: 3} in cart
    assert false == Enum.member?(cart, %{fruit: "orange", count: 1})
    assert false == Enum.empty?(cart)
    assert true == Enum.empty?([])

    assert [%{fruit: "orange", count: 6}] == Enum.filter(cart, &(&1.fruit =~ "o"))

    assert [
             %{fruit: "apple", count: 3},
             %{fruit: "banana", count: 1}
           ] == Enum.reject(cart, &(&1.fruit =~ "o"))

    for %{count: 1, fruit: fruit} <- cart do
      assert "banana" == fruit
    end
  end
end
