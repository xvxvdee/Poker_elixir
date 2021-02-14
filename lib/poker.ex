defmodule Poker do
  # HELPER METHODS

  def checkSuit(num) do
    # Takes a number and returns its suit
    a = num >= 1 and num <= 13
    b = num >= 14 and num <= 26
    c = num >= 27 and num <= 39
    d = num >= 40 and num <= 52

    ans =
      cond do
        a -> 'C'
        b -> 'D'
        c -> 'H'
        d -> 'S'
      end

    ans
  end

  def checkNum(num) do
    #Takes any number and returns its value with the range 1-13
    a = num == 1 or num == 14 or num == 27 or num == 40
    b = num == 2 or num == 15 or num == 28 or num == 41
    c = num == 3 or num == 16 or num == 29 or num == 42
    d = num == 4 or num == 17 or num == 30 or num == 43
    e = num == 5 or num == 18 or num == 31 or num == 44
    f = num == 6 or num == 19 or num == 32 or num == 45
    g = num == 7 or num == 20 or num == 33 or num == 46
    h = num == 8 or num == 21 or num == 34 or num == 47
    i = num == 9 or num == 22 or num == 35 or num == 48
    j = num == 10 or num == 23 or num == 36 or num == 49
    k = num == 11 or num == 24 or num == 37 or num == 50
    l = num == 12 or num == 25 or num == 38 or num == 51
    m = num == 13 or num == 26 or num == 39 or num == 52
    ans =
      cond do
        a -> 1
        b -> 2
        c -> 3
        d -> 4
        e -> 5
        f -> 6
        g -> 7
        h -> 8
        i -> 9
        j -> 10
        k -> 11
        l -> 12
        m -> 13
      end

    ans
  end

  def handToSuit(hand) do
    suits = for n <- hand, do: checkSuit(n)
    suits
    # returns a list of just the hands suits
  end

  def handToNum(hand) do
    num = for n <- hand, do: checkNum(n)
    num
    # returns a list of just the hands values (1-13)
  end

  def sameSuit(hand) do
    lst = handToSuit(hand)
    set = MapSet.new(lst)
    len = String.length(Enum.join(set, ""))
    len == 1
    # takes in hand and returns true if values in the hand have the same suit
  end

  # Check hand without Ace in the middle of it
  def checkSequenceV1(hand) do
    lst = handToNum(hand)
    sorted = Enum.sort(lst)
    lst == sorted
  end

  # Check hand with Ace in the middle of it
  def checkSequenceV2(hand) do
    lst = handToNum(hand)
    temp = Enum.split_while(lst, fn x -> x != 1 end)
    l = Tuple.to_list(temp)

    a = Enum.sort(hd(l))
    b = Enum.sort(hd(tl(l)))
    res = a ++ b
    # IO.puts(hand |> inspect(charlists: :as_lists))
    # IO.puts(res |> inspect(charlists: :as_lists))
    res == lst
  end

  # POKER METHODS
  def fourOfAKind(hand) do
    lst = handToNum(hand)
    lst = Enum.chunk_by(lst, fn x -> x end)
    a = Enum.count(hd(lst))
    b = Enum.count(hd(tl(lst)))
    cond1 = a == 4 and b == 1
    cond2 = a == 1 and b == 4
    IO.puts(a)
    IO.puts(b)
    cond1 or cond2
  end

  def flush(hand) do
    suit = sameSuit(hand)
    num = handToNum(hand)
    seq = checkSequenceV1(num)
    seq2 = checkSequenceV2(num)

    a = hd(num) != 1 and 1 in num
    b = a and not seq2 and suit
    c = not a and not seq and suit
    # IO.puts(suit)
    # IO.puts(b)
    # IO.puts(c)
    ans =
      cond do
        a == true -> b
        a == false -> c
      end

    ans
  end

  def straightFlush(hand) do
    suit = sameSuit(hand)
    num = handToNum(hand)
    seq = checkSequenceV1(num)
    seq2 = checkSequenceV2(num)

    a = hd(num) != 1 and 1 in num
    b = a and seq2 and suit
    c = not a and seq and suit

    ans =
      cond do
        a == true -> b
        a == false -> c
      end

    ans
  end

  def royalFlush(hand) do
    lst = handToNum(hand)
    straightFlush(hand) and 1 in lst
  end

  def fullHouse(hand) do
    lst = handToNum(hand)
    lst = Enum.chunk_by(lst, fn x -> x end)
    a = Enum.count(hd(lst))
    b = Enum.count(hd(tl(lst)))
    cond1 = a == 2 and b == 3
    cond2 = a == 3 and b == 2
    # IO.puts(a)
    # IO.puts(b)
    cond1 or cond2
  end

  def straight(hand) do

  end

  def threeOfAKind(hand) do
    lst = Enum.sort(hand)
    lst = Enum.chunk_by(lst, fn x -> x end)
    lst = Enum.sort_by(lst, &length/1, :desc)
    a = Enum.count(hd(lst))
    b = Enum.count(hd(tl(lst)))
    cond1 = a == 3 and b == 1
    # IO.puts(a)
    # IO.puts(b)
    cond1
  end

  def twoPair(hand) do
    lst = Enum.sort(hand)
    lst = Enum.chunk_by(lst, fn x -> x end)
    lst = Enum.sort_by(lst, &length/1, :desc)
    a = Enum.count(hd(lst))
    b = Enum.count(hd(tl(lst)))
    # IO.puts(a)
    # IO.puts(b)
    a == 2 and b == 2
  end

  def pair(hand) do
    lst = Enum.sort(hand)
    lst = Enum.chunk_by(lst, fn x -> x end)
    lst = Enum.sort_by(lst, &length/1, :desc)
    a = Enum.count(hd(lst))
    b = Enum.count(hd(tl(lst)))
    # IO.puts(a)
    # IO.puts(b)
    a == 2 and b == 1
  end

  def highCard(hand) do
    lst = Enum.sort(hand)
    lst = Enum.reverse(lst)
    hd(lst)
  end
end

# IO.puts(Poker.checkNum(28))
# IO.puts(Poker.checkSequenceV1([2,2,2,1,1]))
# IO.puts(Poker.fullHouse([10, 23, 36, 1, 14]))
# IO.puts(Poker.fullHouse([10,23,33,1,14]))
# IO.puts(Poker.sameSuit([5,6,7,8,9]))
# IO.puts(Poker.straightFlush([1,2,3,4,5]))
# IO.puts(Poker.fourOfAKind([14, 15, 16, 17, 1]))
IO.puts(Poker.threeOfAKind([11, 11, 11, 17, 4]))
IO.puts(Poker.twoPair([14, 14, 16, 16, 1]))
IO.puts(Poker.pair([14, 14, 16, 17, 1]))
IO.puts(Poker.highCard([14, 15, 16, 17, 1]))
