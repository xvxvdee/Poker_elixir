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
    high =
      cond do
        1 in hand -> 1
        13 in hand -> 13
        12 in hand-> 12
        11 in hand-> 11
        10 in hand-> 10
        9 in hand-> 9
        8 in hand-> 8
        7 in hand-> 7
        6 in hand-> 6
        5 in hand-> 5
        4 in hand-> 4
        3 in hand-> 3
        2 in hand-> 2
      end
    high
  end
  def getHighestRankV2(hand) do
    lst = List.flatten(hand)
    # IO.puts(hand|> inspect(charlists: :as_lists))
    # IO.puts(1 in List.flatten(hand))
    high =
      cond do
        1 in lst -> 1
        13 in lst -> 13
        12 in lst-> 12
        11 in lst-> 11
        10 in lst-> 10
        9 in lst-> 9
        8 in lst-> 8
        7 in lst-> 7
        6 in lst-> 6
        5 in lst-> 5
        4 in lst-> 4
        3 in lst-> 3
        2 in lst-> 2
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
  # Used to find the highest rank between hands
  # Example getHandHighRank([[[2,2],[3,3]],[[4,4],[5,5]]])
  # highest must be the head of the enumerable
  def getMultipleRankRecursive([],highest), do: highest
  def getMultipleRankRecursive(choices,highest) do
    a = hd(choices)
    b = a
    high = getHandHighRank([getHandHighRank(a, hd a),getHandHighRank(highest, hd highest)],getHandHighRank(a, hd a))
    ans =
      cond do
        high in a -> b
        high in highest -> highest
      end
    getMultipleRankRecursive(choices --[a] ,ans)
  end

  # Used to find the highest rank of pairs, three of a kinds etc.
  # Example getHandHighRank([[2,2],[3,3]], [2,2])
  # highest must be the head of the enumerable
  def getHandHighRank([], highest), do: highest
  def getHandHighRank(choices, highest) do
    a = hd(hd (choices))
    b = hd (choices)

    high = getHighestRank([getHighestRankV2([hd highest]), getHighestRankV2([a])])

    ans =
      cond do
        high in [a] -> b
        high in [hd highest] -> highest
      end
    getHandHighRank(choices -- [hd choices], ans)
  end

  # Helper method for pairs
  def equalPairs([], lst), do: lst
  def equalPairs(choices, lst) do
    a = hd(choices)

    if Enum.count(Enum.uniq(a)) == 1 do
      equalPairs(choices -- [a], lst)

    else
      equalPairs(choices -- [a], lst ++ [a])
    end
  end

  # Checks if hand is in sequence
  def inSequence(hand) do
    num = for x <- hand, do: hd x # collecting numbers
    setupPairs = Enum.chunk_every(num, 2, 1, :discard)
    adj = for x <- setupPairs, do: hd(tl(x)) - hd(x) #Subtracting adjcant elements
    adj =  MapSet.new(adj)
    strt = String.length(Enum.join(adj, ""))
    condition = strt == 1 and 1 in adj
    if condition == true do
      hand
    else
      false
    end
  end

  # Checks if hand is in the same suit
  def checkSameSuit(hand) do
    suits = for x <- hand, do: tl x # collecting suits
    setSuits =  MapSet.new(suits)
    same = String.length(Enum.join(setSuits, ""))
    condition = same == 1 
    if condition == true do
      hand
    else
      false
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

  # Builds best flush out of a hand
  def bestFlush([],best), do: best --[nil]
  def bestFlush(hand,best) do
    if Enum.count(best)==6 do
      bestFlush([],best)
    else
    high=getHandHighRank(hand,hd hand)
    bestFlush(hand--[high], best++[high])
    end
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
  def royalFlush(hand) do
    opt1=[[10,'H'],[11,'H'],[12,'H'],[13,'H'],[1,'H']]
    opt2=[[10,'C'],[11,'C'],[12,'C'],[13,'C'],[1,'C']]
    opt3=[[10,'D'],[11,'D'],[12,'D'],[13,'D'],[1,'D']]
    opt4=[[10,'S'],[11,'S'],[12,'S'],[13,'S'],[1,'S']]

    if hand==opt1 do
      [10,opt1]
    end
    
    if hand==opt2 do
      [10,opt2]
    end
    
    if hand==opt3 do
      [10,opt3]
    end
    
    if hand==opt4 do
      [10,opt4]
    end
    
    if hand==opt1 and hand==opt1 and hand==opt1 and hand==opt1 do
      highCard(hand)
    end
    
  end

  #straight ----------------------------------------------

  def straight(hand) do 
    straights = Enum.chunk_every(hand,5,1, :discard) # chunk into fives
    checkSequence = for x <- straights, do: inSequence(x)
    build = Enum.reject(checkSequence, fn x -> x==false end)

    ans = 
    cond do
      Enum.count(build)==0 ->  highCard(hand)
      Enum.count(build)==1 ->  [5,hd build]#|> inspect(charlists: :as_lists)
      Enum.count(build)>1 -> [5, getMultipleRankRecursive(build, hd build)] #|> inspect(charlists: :as_lists)
    end
    ans
  end

  #  flush -----------------------------------------------
  def flush(hand) do 
    sorted = Enum.sort(hand, &(tl(&1) == tl(&2)))
    checkflushes = Enum.chunk_by(sorted, fn x -> tl x end)
    build = Enum.reject(checkflushes, fn x -> Enum.count(x)<5 end)
    flushes= for x <- build, do: bestFlush(x,[nil])
    
    ans = 
    cond do
      Enum.count(build)==0 ->  highCard(hand)
      Enum.count(build)==1 ->[6, hd flushes]#|> inspect(charlists: :as_lists)
      Enum.count(build)>1 -> [6, getMultipleRankRecursive(flushes, hd flushes)]
    end
    ans
  end

  # straight Flush ----------------------------------------
  def straightFlush(hand) do
    strCheck=straight(hand)
    flCheck= flush(hand)

    if 5 in [hd strCheck] && 6 in [hd flCheck] do
      sorted = Enum.sort(hand, &(tl(&1) == tl(&2)))
      checkflushes = Enum.chunk_by(sorted, fn x -> tl x end)
      straights = for x <- checkflushes, do: Enum.chunk_every(x,5,1, :discard)
      straights=List.flatten(straights)
      straights=Enum.chunk_every(straights,2,2, :discard)
      straights=Enum.chunk_every(straights,5)
      checkSequence = for x <- straights, do: inSequence(x)
      build = Enum.reject(checkSequence, fn x -> x==false end)
      
      ans = 
      cond do
        Enum.count(build)==0 ->  highCard(hand)
        Enum.count(build)==1 ->  [5,hd build]#|> inspect(charlists: :as_lists)
        Enum.count(build)>1 -> [5, getMultipleRankRecursive(build, hd build)] #|> inspect(charlists: :as_lists)
      end
      ans #|> inspect(charlists: :as_lists)
    else
      highCard(hand)
    end 
  end

  # high card --------------------------------------------
  def highCard(hand) do
    card = getHandHighRank(hand, hd(hand))
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

  def twoPair(hand) do
    lst = Enum.chunk_by(hand, fn x -> hd(x) end)
    lst2 = for x <- lst, do: x
    lst2 = equalPairs(lst2, [])
    cards = for x <- lst2, do: [hd(hd(x)), hd(hd(tl(x)))]

    cards |> inspect(charlists: :as_lists)
  end

  # pair ------------------------------------------------------
  def pair(hand) do
    lst = Enum.chunk_by(hand, fn x -> hd(x) end)
    lst2 = for x <- lst, do: x
    lst2 = equalPairs(lst2, [])
    # cards = for x <- lst2, do: [hd(hd(x)), hd(hd(tl(x)))]
    [2, hd(lst2)]
    # lst = Enum.take_while(lst2, fn x -> hd(hd(x)) == hd(hd(getHandHighRank(cards, hd(cards)))) end)
    # lst = [hd(hd(lst))] ++ [hd(tl(hd(lst)))]
    # [2, lst]
  end


  #TIE CONDITIONS ----------------------------------------------



  # ----------------------------------------------------

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

#IO.puts(Poker.bestFlush([[3, "C"], [6, "C"], [4, "C"], [9, "C"], [10, "C"],[11, "C"]],[nil]))
#IO.puts( Poker.deal([ 9,  8,  7,  6,  5,  4,  3,  2,  1 ]))
#IO.puts(Poker.flush([[3, "C"], [6, "C"], [4, "C"], [9, "C"], [10, "C"], [11, "C"], [11, "S"]]))
#IO.puts(Poker.deal([ 9,  8,  7,  6,  5,  4,  3,  2,  1 ]))
#IO.puts(Poker.getHandHighRank([[[1, "C"], [2, "C"], [3, "C"], [4, "C"], [5, "C"]], [[2, "C"], [3, "C"], [4, "C"], [5, "C"], [6, "C"]]], ))

IO.puts(Poker.royalFlush([[10,"H"],[11,"H"],[12,"H"],[13,"H"],[1,"H"]]))

# IO.inspect(Poker.deal([ 9,  8,  7,  6,  5,  4,  3,  2,  1 ]))
# IO.puts(Poker.straightFlush(hd tl Poker.deal([ 9,  8,  7,  6,  5,  4,  3,  2,  1 ])))
#IO.puts(Poker.straightFlush([[1, "C"], [2, "C"], [3, "C"], [4, "C"], [5, "C"], [6, "C"], [7, "H"]]))
#IO.puts(Poker.getMultipleRankRecursive([[[3, "C"], [2, "C"], [3, "C"], [4, "C"], [5, "C"]], [[2, "C"], [3, "C"], [4, "C"], [5, "C"], [6, "C"]], [[9, "C"], [3, "C"], [4, "C"], [5, "C"], [6, "C"]]],[[3, "C"], [2, "C"], [3, "C"], [4, "C"], [5, "C"]]))
# IO.inspect(Poker.twoPair(hd Poker.deal([ 40, 52, 46, 11, 48, 27, 24, 33, 37 ])))
#IO.puts(Poker.royalFlush([[10,'C'],[11,'H'],[12,'H'],[13,'H'],[1,'H']]))


# IO.inspect(Poker.bestPair([[1,1], [2,2]], []))
