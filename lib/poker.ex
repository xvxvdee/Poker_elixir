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

  def getHighestRank(hand) do
    lst = handToNum(hand)

    high =
      cond do
        1 in lst -> 1
        13 in lst -> 13
        12 in lst -> 12
        11 in lst -> 11
        10 in lst -> 10
        9 in lst -> 9
        8 in lst -> 8
        7 in lst -> 7
        6 in lst -> 6
        5 in lst -> 5
        4 in lst -> 4
        3 in lst -> 3
        2 in lst -> 2
      end

    high
  end

  def checkNum(num) do
    # Takes any number and returns its value with the range 1-13
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

  # Used to find the highest rank of pairs, three of a kinds etc. 
  # Example getHighRankRecursive([[2,2],[3,3]], [2,2])
  # highest must be the head of the enumerable
  def getHighRankRecursive([], highest), do: highest

  def getHighRankRecursive(choices, highest) do
    a = hd(choices)
    high = getHighestRank([getHighestRank(highest), getHighestRank(a)])

    ans =
      cond do
        high in handToNum(a) -> a
        high in handToNum(highest) -> highest
      end

    getHighRankRecursive(choices -- [a], ans)
  end

  # Helper method for pairs
  def equalPairs([], lst), do: lst

  def equalPairs(choices, lst) do
    a = hd(choices)

    if Enum.count(Enum.uniq(a)) == 1 do
      equalPairs(choices -- [a], lst ++ [a])
    else
      equalPairs(choices -- [a], lst)
    end
  end

  # Needs to be fixed
  def finalHand(hand) do
    setup = for n <- hand, do: "#{to_string(checkNum(n))}#{checkSuit(n)}"
    setup |> inspect(charlists: :as_lists)
  end

  # Returns a hand in the form [[rank,suit],[rank,suit],etc]
  def transformHand(hand) do
    transform = for n <- hand, do: [checkNum(n), to_string(checkSuit(n))]
    transform = Enum.sort(transform)
    transform
  end

  def handToNum(hand) do
    num = for n <- hand, do: checkNum(n)
    num
    # returns a list of just the hands values (1-13)
  end

  # POKER METHODS  https://www.fgbradleys.com/et_poker.asp
  #|> inspect(charlists: :as_lists)

  # 1. Royal flush, straight flush, flush, straight, high card - Deandra

  # Royal flush ------------------------------------------
  # def royalFlush(hand) do
  #   opt1=[[10,'H'],[11,'H'],[12,'H'],[13,'H'],[1,'H']] 
  #   opt2=[[10,'C'],[11,'C'],[12,'C'],[13,'C'],[1,'C']] 
  #   opt3=[[10,'D'],[11,'D'],[12,'D'],[13,'D'],[1,'D']] 
  #   opt4=[[10,'S'],[11,'S'],[12,'S'],[13,'S'],[1,'S']]
    
  #   # IO.puts(options)
  #   # if options = true do
  #   #   [10,hand]|> inspect(charlists: :as_lists)
  #   # else
  #   #   highCard(hand)|> inspect(charlists: :as_lists)
  #   # end
  # end

  #straight ----------------------------------------------
  def straight(hand) do
    # st = for x <- hand, do: hd(tl((x))) - hd(x)
    # IO.puts(st)
    IO.puts(hand|> inspect(charlists: :as_lists))
    head = hd hand
    IO.puts( head)
    IO.puts(hd head)

  end

  #  flush -----------------------------------------------
  # def flush(hand) do
  # end

  # straight Flush ----------------------------------------
  # def straightFlush(hand) do
  # end

  # high card --------------------------------------------
  def highCard(hand) do
    card = getHighestRank(hand)
    [1,card]|> inspect(charlists: :as_lists)

  end

  #TIE CONDITIONS ----------------------------------------



  #------------------------------------------------------

  # 2. Four of a kind, Full house, Three of a kind, two pair, pair - Vanessa

  #  Four of a kind--------------------------------------------

  # def fourKind(hand) do
  # end

  # Full house ------------------------------------------------

  # def fullHouse(hand) do
  # end

  # Three of a kind--------------------------------------------

  # def threeKind(hand) do
  # end

  # two pair --------------------------------------------------

  # def twoPair(hand) do
  # end

  # pair ------------------------------------------------------

  # def pair(hand) do
  # end

  #TIE CONDITIONS ----------------------------------------------



  #----------------------------------------------------
  
  # 3. deal method

  # deal --------------------------------------------------------
  # returns two hands [hand1,hand2]
  def deal(cards) do
    cards = cards
    hand1=[hd(cards),hd tl tl cards]
    hand2=[hd(tl(cards)), hd(tl(tl(tl(cards))))]
    cards = cards -- hand1
    cards = cards -- hand2
    hand1 = transformHand(Enum.sort(hand1 ++ cards))
    hand2 = transformHand(Enum.sort(hand2 ++ cards))
    [hand1,hand2]
  end
end

IO.puts(Poker.deal([ 9,  8,  7,  6,  5,  4,  3,  2,  1 ]))
IO.puts(Poker.straight(hd Poker.deal([ 9,  8,  7,  6,  5,  4,  3,  2,  1 ])))
#IO.puts(Poker.royalFlush([[10,'C'],[11,'H'],[12,'H'],[13,'H'],[1,'H']]))