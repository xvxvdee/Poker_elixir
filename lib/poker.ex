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

  def getHRInt(hand) do
    # Takes a hand and returns the highest rank
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

  # Works with transform method
  def getHRMatrix(hand) do
    lst = List.flatten(hand)
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

  def getMultipleRankStraight([],highest), do: highest
  def getMultipleRankStraight(choices,highest) do
    a = hd choices
    tail = List.last(a)
    high = getHRMatrix([getHRInt(tail),getHRInt(List.last(highest))])
    ans =
      cond do
        high in tail -> a
        high in highest -> highest
      end
    getMultipleRankStraight(choices --[a] ,ans)
  end

  # Used to find the highest rank of pairs, three of a kinds etc.
  # Example getHandHighRank([[2,2],[3,3]], [2,2])
  # highest must be the head of the enumerable
  def getHandHighRank([], highest), do: highest
  def getHandHighRank(choices, highest) do
    a = hd(hd (choices))
    b = hd (choices)

    high = getHRInt([getHRMatrix([hd highest]), getHRMatrix([a])])

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
  def inSequence(hand) do # May have hands in reverse order
    num = for x <- hand, do: hd x # collecting numbers
    num = Enum.sort(num)
    setupPairs = Enum.chunk_every(num, 2, 1, :discard)
    adj = for x <- setupPairs, do: hd(tl(x)) - hd(x) #Subtracting adjcant elements
    adj =  MapSet.new(adj)
    strt = String.length(Enum.join(adj, ""))
    # IO.inspect(adj)
    # IO.puts(strt)
    condition = strt == 1 and 1 in adj
    condition2 = strt ==2 and 1 in adj and 8 in adj
    if condition or condition2 do
      hand
    else
      false
    end
  end


  # Returns final hand in correct format
  def finalHand(hand) do
    if (is_number(hd hand)) do
      hand = [hand]
      setup = for n <- hand, do: "#{to_string(checkNum(hd n))}#{hd tl n}"
      setup
    else
      setup = for n <- hand, do: "#{to_string(checkNum(hd n))}#{hd tl n}"
      setup
    end

  end

def sameSuit(hand) do
  lst = for x <-hand, do: hd tl x
  set = MapSet.new(lst)
  len = String.length(Enum.join(set, ""))
  len == 1
  # takes in hand and returns true if values in the hand have the same suit
end

  # Returns a hand in the form [[rank,suit],[rank,suit],etc]
  def transformHand(hand) do
    transform = for n <- hand, do: [checkNum(n), to_string(checkSuit(n))]
    transform = Enum.sort(transform)
    transform
  end

  # Builds best flush out of a hand
  def buildBestFlush([],best), do: best --[nil]
  def buildBestFlush(hand,best) do
    if Enum.count(best)==6 do
      buildBestFlush([],best)
    else
    high=getHandHighRank(hand,hd hand)

    buildBestFlush(hand--[high], best++[high])
    end
  end

  def getSameSuit([],_suit,lst), do: lst-nil
  def getSameSuit(hand,suit,lst)do
    a = hd hand
    IO.puts( hd tl a)

    ans =
     cond do
      suit in a -> getSameSuit(hand-- [a],suit,lst ++ [a] )
      suit not in a ->  getSameSuit(hand--[a],suit,lst)
     end
    ans
  end

  def addOne(hand,one) do
    #IO.inspect(Enum.member?(hand,hd one))
    ans =
      cond do
      Enum.member?(hand,hd one)==true -> hand   
      Enum.member?(hand,hd one)==false-> hand ++ [hd one]
      end 
    ans
  end


  # POKER METHODS  https://www.fgbradleys.com/et_poker.asp
  #|> inspect(charlists: :as_lists)

  # 1. Royal flush, straight flush, flush, straight, high card - Deandra

  # Royal flush ------------------------------------------
  def royalFlush(hand) do

    opt1=[[10,"H"],[11,"H"],[12,"H"],[13,"H"],[1,"H"]]
    opt2=[[10,"C"],[11,"C"],[12,"C"],[13,"C"],[1,"C"]]
    opt3=[[10,"D"],[11,"D"],[12,"D"],[13,"D"],[1,"D"]]
    opt4=[[10,"S"],[11,"S"],[12,"S"],[13,"S"],[1,"S"]]

    count1 =Enum.count(Enum.reject((for x <- hand, do: x  in opt1), fn x -> x==false end))
    count2 =Enum.count(Enum.reject((for x <- hand, do: x  in opt2), fn x -> x==false end))
    count3 =Enum.count(Enum.reject((for x <- hand, do: x  in opt3), fn x -> x==false end))
    count4 =Enum.count(Enum.reject((for x <- hand, do: x  in opt4), fn x -> x==false end))

    ans = cond do
      count1==5 -> [10,opt1]
      count2==5 -> [10,opt2]
      count3==5 -> [10,opt3]
      count4==5 -> [10,opt4]
      count1 !=5 -> false
      count2 !=5 ->false
      count3 !=5 -> false
      count4 !=5 ->false

    end
    ans

  end

  #straight ----------------------------------------------

 

  def straight(hand) do
    hand =Enum.sort(hand)
    straights = Enum.chunk_every(hand,5,1, :discard) # chunk into fives
    ones = Enum.reject(hand, fn x -> 1 not in x end)
    straightsUp = 
      cond do
      Enum.count(ones)==1 ->  for x <-straights, do: addOne(x,ones)
      Enum.count(ones)!=1 ->  straights
      end
 
    checkSequence = for x <- straightsUp, do: inSequence(x)
    build = Enum.reject(checkSequence, fn x -> x==false end)
    # IO.puts(build|> inspect(charlists: :as_lists))
    # IO.puts(checkSequence|> inspect(charlists: :as_lists))

    ans =
    cond do
      Enum.count(build)==0 ->  false#|> inspect(charlists: :as_lists)
      Enum.count(build)==1 ->  [5,hd build]#|> inspect(charlists: :as_lists)
      Enum.count(build)>1 -> [5, buildBestFlush(build, hd build)] #|> inspect(charlists: :as_lists)

    end
    ans
  end


  #  flush -----------------------------------------------
  def flush(hand) do

    h = Enum.reject(hand, fn x -> "H" not in x end)
    d = Enum.reject(hand, fn x -> "D" not in x  end)
    c = Enum.reject(hand, fn x -> "C" not in x  end)
    s = Enum.reject(hand, fn x -> "S" not in x  end)

    same =  [h]
    same = same ++ [d]
    same = same ++ [s]
    same = same ++ [c]

    same = Enum.reject(same, fn x -> Enum.count(x)<5 end)

    if Enum.empty?(same)==true do
      false
    else
      same = List.flatten(same)
      build= Enum.chunk_every(same,2,2, :discard)
      build=Enum.sort(build)
      flushes = buildBestFlush(build,[nil])
      [6,flushes]
     end

  end

  # straight Flush ----------------------------------------
  def straightFlush(hand) do

    if straight(hand) && flush(hand) do
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
        Enum.count(build)==0 ->  false
        Enum.count(build)==1 ->  [9,hd build]
        Enum.count(build)>1 -> [9, getMultipleRankStraight(build, hd build)]
      end
      ans
    else
      false
    end
  end

  # high card --------------------------------------------
  def highCard(hand) do
    card = getHandHighRank(hand, hd(hand))
    [1,[card]]
  end

  #TIE CONDITIONS ----------------------------------------

  def tie_higherTopCard(check1,check2,og1,og2) do
    a = List.last(check1)
    b =  List.last(check2)
    high = getHRInt([getHRMatrix(a),getHRMatrix(b)])
    ans =
    cond do
      high in a ->og1
      high in b ->og2
      high in a and high in b ->  tie_higherTopCard(check1--[high],check2--[high],og1,og2)
    end
    ans
  end

  def tie_flush(hand1,hand2,og1,og2) do
    c1 = highCard(hand1)
    c2 = highCard(hand2)
    a= hd c1
    b = hd c2

    high=getHRInt([a,b])

    ans =
    cond do
      high in c1 -> og1
      high in c1 -> og2
      high in c1 and high in c2 -> tie_flush(hand1 --[c1],hand2 --[c2],og1,og2)
    end
    ans

  end

  #------------------------------------------------------

  # 2. Four of a kind, Full house, Three of a kind, two pair, pair - Vanessa

  #  Four of a kind--------------------------------------------

  def fourKind(hand) do
    # chunk cards based on rank and remove cards if the # of cards don't equal to 4
    lst = Enum.chunk_by(hand, fn x -> hd(x) end)
    four = Enum.reject(lst, fn x -> Enum.count(x) != 4 end)

    if four == [] do
      false
    else
      [8, hd four]
    end

  end

  # Full house ------------------------------------------------

  def fullHouse(hand) do

    if threeKind(hand) && pair(hand) do
      [7, (hd(tl(threeKind(hand))) ++ hd((tl(pair(hand)))))]
    else
      false
    end

  end

  # Three of a kind--------------------------------------------

  def threeKind(hand) do
    # chunk cards based on rank and remove cards if the # of cards don't equal to 3
    lst = Enum.chunk_by(hand, fn x -> hd(x) end)
    three = Enum.reject(lst, fn x -> Enum.count(x) != 3 end)

    cond do
      three == [] -> false

      # if theres more than 1 three of a kind, find the better one
      length(three) > 1 ->

        cmp = hd(three) ++ hd(tl(three))
        leftover = hand -- Enum.take_while(cmp, fn x -> hd(x) == hd(getHandHighRank(cmp, hd(cmp))) end)
        x = getHandHighRank(leftover, hd(leftover))
        leftover = leftover -- [x]
        y = getHandHighRank(leftover, hd(leftover))
        [4, Enum.take_while(cmp, fn x -> hd(x) == hd(getHandHighRank(cmp, hd(cmp))) end), [x] ++ [y]]

      # if theres 1 three of a kind
      length(three) == 1 ->
        leftover = hand -- (hd three)
        x = getHandHighRank(leftover, hd(leftover))
        leftover = leftover -- [x]
        y = getHandHighRank(leftover, hd(leftover))
        [4, (hd three), [x] ++ [y]]
    end

  end

  # two pair --------------------------------------------------

  def twoPair(hand) do
    lst = Enum.chunk_by(hand, fn x -> hd(x) end)
    lst2 = for x <- lst, do: x
    lst2 = equalPairs(lst2, [])

    # if there's less than 2 pairs
    if length(lst2) < 2 do
      false
    else
      # get the 2 best pairs
      a = getMultipleRankRecursive(lst2, hd(lst2))
      lst2 = lst2 -- [a]
      b = getMultipleRankRecursive(lst2, hd(lst2))
      leftover = ((hand) -- a) -- b
      x = getHandHighRank(leftover, hd(leftover))
      [3, a ++ b, x]

    end

  end

  # pair ------------------------------------------------------

  def pair(hand) do

    lst = Enum.chunk_by(hand, fn x -> hd(x) end)
    lst2 = Enum.reject(lst, fn x -> Enum.count(x) != 2 end)

    if lst2 == [] do
      false
    else

      leftover = ((hand) -- hd lst2)
      x = getHandHighRank(leftover, hd(leftover))
      leftover = ((leftover) -- [x])
      y = getHandHighRank(leftover, hd(leftover))
      leftover = ((leftover) -- [y])
      z = getHandHighRank(leftover, hd(leftover))
      [2, hd(lst2), [x]++[y]++[z]]
    end

  end


  #TIE CONDITIONS ----------------------------------------------

  # Four of a Kind Tie -----------------------------------------
  def tie_fourKind(hand1, hand2) do
    getMultipleRankRecursive([(hand1), (hand2)] , hand1)
  end

  # Full House Tie ---------------------------------------------
  def tie_fullHouse(hand1, hand2) do
    lst = Enum.chunk_by(hand1, fn x -> hd(x) end)
    lst2 = Enum.chunk_by(hand2, fn x -> hd(x) end)

    # if the 3 of a kind is the exact same
    if hd(hd(hd(lst))) == hd(hd(hd(lst2))) do
      x = getMultipleRankRecursive([(hd tl lst), (hd tl lst2)] , hd tl lst)
      if x == (hd tl lst) do
        hand1
      else
        hand2
      end

    else
      x = getMultipleRankRecursive([(hd lst), (hd lst2)] , hd tl lst)
      if x == (hd lst) do
        hand1
      else
        hand2
      end
    end

  end


  # Three of a Kind Tie -----------------------------------------
  def tie_threeKind(hand1, leftover1, hand2, leftover2) do

    if hd(hd(hand1)) == hd(hd(hand2)) do
      x = getMultipleRankRecursive([(leftover1), (leftover2)] , leftover1)
      if x == (leftover1) do
        hand1
      else
        hand2
      end
    else

      x = getMultipleRankRecursive([(hand1), (hand2)] , hand1)
      if x == hand1 do
        hand1
      else
        hand2
      end
    end

  end


  # # Two Pair Tie ------------------------------------------------
  def tie_twoPair(hand1, leftover1, hand2, leftover2) do

    # if first pair is the same
    if hd(hd(hand1)) == hd(hd(hand2)) do
      x = Enum.drop_while(hand1, fn x -> hd(x) == hd(hd(hand1)) end)
      y = Enum.drop_while(hand2, fn x -> hd(x) == hd(hd(hand1)) end)

      # if second pair is the same
      if x == y do
        high = getHandHighRank([leftover1] ++ [leftover2], leftover1)

        if high == leftover1 do
          hand1
        else
          hand2
        end

      else
        high = getMultipleRankRecursive([(x), (y)] , x)
        if high == x do
          hand1
        else
          hand2
        end
      end

    else
      x = Enum.take_while(hand1, fn x -> hd(x) == hd(hd(hand1)) end)
      y = Enum.take_while(hand2, fn x -> hd(x) == hd(hd(hand2)) end)

      high = getMultipleRankRecursive([(x), (y)] , x)
      if high == x do
        hand1
      else
        hand2
      end
    end

  end

  # # Pair Tie ----------------------------------------------------
  def tie_pair(hand1, leftover1, hand2, leftover2) do

    # if first pair is the same
    if hd(hd(hand1)) == hd(hd(hand2)) do

      # highest elem in leftover
      x = getHandHighRank(leftover1, hd leftover1)
      y = getHandHighRank(leftover2, hd leftover2)

      # if highest elem in leftover are the same
      if hd(x) == hd(y) do
        leftover1 = (leftover1) -- [x]
        leftover2 = (leftover2) -- [y]
        x = getHandHighRank(leftover1, hd leftover1)
        y = getHandHighRank(leftover2, hd leftover2)

        # if 2nd highest elem in leftover are the same
        if hd(x) == hd(y) do
          leftover1 = (leftover1) -- [x]
          leftover2 = (leftover2) -- [y]

          if getHandHighRank(leftover1 ++ leftover2, leftover1) == leftover1 do
            hand1
          else
            hand2
          end

        # if 2nd highest elem in leftover are not the same --> return the high card between the 2
        else
          if getHandHighRank([[x] ++ [y]] , x) == x do
            hand1
          else
            hand2
          end

        end
      # if highest elem in leftover are not the same --> return the high card between the 2
      else

        if getHandHighRank([[x] ++ [y]] , x) == x do
          hand1
        else
          hand2
        end

      end

    else
      getMultipleRankRecursive([(hand1), (hand2)] , hand1)
    end
  end



  #-------------------------------------------------------------

  # 3. deal method

  # deal --------------------------------------------------------
  # returns two hands [hand1,hand2]
  def deal(cards) do
    hand1=[hd(cards),hd tl tl cards]
    hand2=[hd(tl(cards)), hd(tl(tl(tl(cards))))]

    indivHand1 = transformHand(Enum.sort(hand1))
    indivHand2 = transformHand(Enum.sort(hand2))

    cards = cards -- hand1
    cards = cards -- hand2
    hand1 = transformHand(Enum.sort(hand1 ++ cards))
    hand2 = transformHand(Enum.sort(hand2 ++ cards))

    player1 = findHand(hand1, indivHand1)
    player2 = findHand(hand2, indivHand2)

    res =
    cond do
      (hd player1) > (hd player2) ->
        finalHand(hd tl player1)

      (hd player1) < (hd player2) ->
        finalHand(hd tl player2)

      (hd player1) == (hd player2) ->
        finalHand(breakTie(player1, player2))

    end
    res
  end

  # make cases to find the hand and return the hand
  # ex. returns [1, [cards], [side cards]]
  def findHand(hand, indivHand) do
    res =
    cond do
      royalFlush(hand) ->
        royalFlush(hand) #10

      straightFlush(hand) ->
        straightFlush(hand) #9

      fourKind(hand) ->
        fourKind(hand) #8

      fullHouse(hand) ->
        fullHouse(hand) #7

      flush(hand) ->
        flush(hand) #6

      straight(hand) ->
        straight(hand) #5

      threeKind(hand) ->
        threeKind(hand) #4

      twoPair(hand) ->
        twoPair(hand) #3

      pair(hand) ->
        pair(hand) #2

      highCard(hand) ->
        highCard(indivHand) #1
    end
    res
  end

  def breakTie(hand1, hand2) do
    num = hd hand1
    x = hd tl hand1
    y = hd tl hand2

    if num == 4 || num == 3 || num == 2 do
      x1 = hd tl tl hand1
      y1 = hd tl tl hand2

      cond do
        num == 4 ->
          tie_threeKind(x, x1, y, y1)
        num == 3 ->
          tie_twoPair(x, x1, y, y1)
        num == 2 ->
          tie_pair(x, x1, y, y1)
      end

    else

      cond do
        num == 9 ->
          tie_higherTopCard(x, y, x, y)
        num == 8 ->
          tie_fourKind(x, y)
        num == 7 ->
          tie_fullHouse(x, y)
        num == 6 ->
          tie_flush(x, y, x, y)
        num == 5 ->
          tie_higherTopCard(x, y, x, y)
        num == 1 ->
          getHandHighRank([(hd x), (hd y)], (hd x))

      end

    end

  end
end


# TESTING TESTING TESTING
# IO.puts("Test 1")
# #lst = [ 38, 36, 37, 29, 24, 34, 31, 35, 16 ] #18
# lst2 = [ 14, 43,  9, 12, 38, 47, 36, 37, 26 ] #16
# #lst4=[ 37, 13, 38, 29, 24, 16, 31, 34, 35 ] #17 
# #IO.puts(Poker.flush([[3, "D"], [5, "H"], [8, "H"], [9, "H"], [11, "D"], [11, "H"], [12, "H"]]))
# #IO.puts(Poker.sameSuit([[1, "C"], [2, "C"], [3, "C"], [6, "C"], [8, "C"], [10, "C"],[11, "C"]]))
# IO.puts("16 -----------------------------------------------")
# IO.inspect(Poker.straight([[1, "D"], [8, "S"], [9, "C"], [10, "H"], [11, "H"], [12, "H"], [13,"D"]]))
# IO.inspect(Poker.straight([[4, "S"], [8, "S"], [10, "H"], [11, "H"], [12, "C"], [12, "H"], [13, "D"]]))
# IO.inspect(Poker.deal(lst2))
# IO.puts("[10H, 11H 12H, 13D, 1D]<----WINNER")
# IO.puts("Test 1")
# lst = [ 38, 36, 37, 29, 24, 34, 31, 35, 16 ] #18
# lst2 = [ 14, 43,  9, 12, 38, 47, 36, 37, 26 ] #16
# lst4=[ 37, 13, 38, 29, 24, 16, 31, 34, 35 ] #17
#IO.puts(Poker.flush([[3, "D"], [5, "H"], [8, "H"], [9, "H"], [11, "D"], [11, "H"], [12, "H"]]))
#IO.puts(Poker.sameSuit([[1, "C"], [2, "C"], [3, "C"], [6, "C"], [8, "C"], [10, "C"],[11, "C"]]))
# IO.puts("18 -----------------------------------------------")
# IO.inspect(Poker.flush([[3, "D"], [3, "H"], [5, "H"], [8, "H"], [9, "H"], [10, "H"], [11, "D"]]))
# IO.inspect(Poker.flush([[3, "D"], [5, "H"], [8, "H"], [9, "H"], [11, "D"], [11, "H"], [12, "H"]]))
# IO.inspect(Poker.deal(lst))
# IO.puts("[[12, H], [11, H], [9, H], [8, H], [5, H]] <----WINNER")
# IO.puts("17 -----------------------------------------------")
# IO.inspect(Poker.flush([[3, "D"], [5, "H"], [8, "H"], [9, "H"], [11, "D"], [11, "H"], [12, "H"]]))
# IO.inspect(Poker.flush([[3, "D"], [3, "H"], [5, "H"], [8, "H"], [9, "H"], [11, "D"], [13, "C"]]))
# IO.inspect(Poker.deal(lst4))
# IO.puts("[12H, 11H, 9H, 8H, 5H]<----WINNER")
# IO.puts("16 -----------------------------------------------")
# IO.inspect(Poker.straight([[1, "D"], [8, "S"], [9, "C"], [10, "H"], [11, "H"], [12, "H"], [13,"D"]]))
# IO.inspect(Poker.straight([[4, "S"], [8, "S"], [10, "H"], [11, "H"], [12, "C"], [12, "H"], [13, "D"]]))
# IO.inspect(Poker.deal(lst2))
# IO.puts("[10H, 11H 12H, 13D, 1D]<----WINNER")
# IO.inspect("Test 2")
# lst =   [ 52, 30, 39, 17, 25, 12, 51, 41, 44 ]
# IO.inspect(Poker.deal(lst))
