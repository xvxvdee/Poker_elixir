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

  def getHighestRank(hand,remove) do
    lst = handToNum(hand)
    lst = lst -- remove
    high=
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

def recurHighRanks([],highest),do: highest |> inspect(charlists: :as_lists)
def recurHighRanks(choices,highest)do
  a = hd choices
  high = getHighestRank([getHighestRank(highest,[]),getHighestRank(a,[])],[])
  ans =
    cond do
      high in handToNum(a) -> a
      high in handToNum(highest) -> highest
    end 
  recurHighRanks(choices -- [a],ans)
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

  def finalHand(hand) do
    setup = for n <- hand, do: "#{to_string(n)}#{checkSuit(n)}"
    setup |> inspect(charlists: :as_lists)
  end


  def sameSuit(hand) do
    lst = handToSuit(hand)
    set = MapSet.new(lst)
    len = String.length(Enum.join(set, ""))
    len == 1
    # takes in hand and returns true if values in the hand have the same suit
  end

  
  def getDuplicates([],_element,lst), do: lst--[nil]|> inspect(charlists: :as_lists)
  def getDuplicates(hand,element,lst) do
    if element != hd hand do
      getDuplicates(hand -- [hd hand],element,lst)      
    else
      getDuplicates(hand -- [hd hand],element,lst ++ [hd hand])     
    end 
  end

  # Check hand without Ace in the middle of it
  def checkSequenceV1(hand) do
    # hand = Enum.sort(hand)
    lst = handToNum(hand)
    temp = Enum.chunk_every(lst,2, 1, :discard)
    check = for x <- temp, do: hd(tl(x))-hd(x)
    set = MapSet.new(check)
    len = String.length(Enum.join(set, ""))
    len == 1 and 1 in set
  end

  # Check hand with Ace in the middle of it
  def checkSequenceV2(hand) do
    lst = handToNum(hand)
    temp = Enum.split_while(lst, fn x -> x != 1 end)
    l = Tuple.to_list(temp)
    # IO.inspect(l)
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
    lst = Enum.sort(lst)
    lst = Enum.chunk_by(lst, fn x -> x end)
    four = Enum.reject(lst, fn x -> Enum.count(x) < 4 end)
    four = List.flatten(four)
    ans = 
      cond do
        Enum.empty?(four)==false -> four
        four == [] -> false
      end
    ans|> inspect(charlists: :as_lists)
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
  
    ans =
      cond do
        a or b== true -> hand|> inspect(charlists: :as_lists)
        a or c== true -> hand|> inspect(charlists: :as_lists)
        a or b == false -> false
        a or c == false -> false
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
        a or b== true -> hand|> inspect(charlists: :as_lists)
        a or c== true -> hand|> inspect(charlists: :as_lists)
        a or b == false -> false
        a or c == false -> false
      end
  
    ans
  end

  def royalFlush(hand) do
    sflush = 
    cond do
      Enum.empty?(straightFlush(hand))==true -> false
      Enum.empty?(straightFlush(hand))==false -> true
    end
    check = sflush and 1 in hand
    ans =
    cond do
      check ==true -> hand|> inspect(charlists: :as_lists)
      check ==false -> false
    end
    ans
  end

  def fullHouse(hand) do
    lst = handToNum(hand)
    lst = Enum.chunk_by(lst, fn x -> x end)
    a = Enum.count(hd(lst))
    b = Enum.count(hd(tl(lst)))
    IO.puts(hd lst)
    cond1 = a == 2 and b == 3
    cond2 = a == 3 and b == 2
    cond1 or cond2
  end

  def straight(hand) do
    num = handToNum(hand)
    seq = checkSequenceV1(num)
    seq2 = checkSequenceV2(num)

    a = hd(num) != 1 and 1 in num
    b = a and seq2
    c = not a and seq

    ans =
      cond do
        a == true -> b
        a == false -> c
      end

    ans
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

  #Tie methods
  def tie_fourkind(hand1,hand2,type) do
    lst1 = handToNum(hand1)
    lst1 = Enum.chunk_by(lst1, fn x -> x end)
    lst2 = handToNum(hand2)
    lst2 = Enum.chunk_by(lst2, fn x -> x end)
    a = Enum.count(hd(lst1))
    b = Enum.count(hd(tl(lst1)))
    c = Enum.count(hd(lst2))
    d = Enum.count(hd(tl(lst2)))

    if type == 1 do
      check1 =
        cond do
          a==4 -> hd(lst1)
          b==4 ->(hd(tl(lst1)))
        end
        check2 =
        cond do
          c==4 -> hd(lst2)
          d==4 ->(hd(tl(lst2)))
        end
      rank =[getHighestRank(check1,[]),getHighestRank(check2,[])]
      high = getHighestRank(rank,[])
      if high in check1 do
        IO.puts(check1|> inspect(charlists: :as_lists))
      else
        IO.puts(check2|> inspect(charlists: :as_lists))

      end

    else
      check1 =
      cond do
        a==1 -> hd(lst1)
        b==1 ->(hd(tl(lst1)))
      end
      check2 =
      cond do
        c==1 -> hd(lst2)
        d==1 ->(hd(tl(lst2)))
      end
      rank =[getHighestRank(check1,[]),getHighestRank(check2,[])]
      high = getHighestRank(rank,[])
      if high in check1 do
        IO.puts(check1|> inspect(charlists: :as_lists))

      else
        IO.puts(check2|> inspect(charlists: :as_lists))

      end
    end
  end

  #FullHouse Tie
  def tie_fullhouse(hand1,hand2,_type) do
    test = for n <- hand1, do: getDuplicates(hand1,n,[])
    test = Enum.uniq(test)
    test|> inspect(charlists: :as_lists)
    hd test


    # lst1 = handToNum(hand1)
    # lst1 = Enum.chunk_by(lst1, fn x -> x end)
    # lst2 = handToNum(hand2)
    # lst2 = Enum.chunk_by(lst2, fn x -> x end)
    # a = hd(lst1)
    # b = hd(tl(lst1))
    # c = hd(lst2)
    # d = hd(tl(lst2))
    # IO.puts(b|> inspect(charlists: :as_lists))
    # if type == 1 do
    #   check1 =
    #     cond do
    #       Enum.count(a)==3 -> a
    #       Enum.count(b)==3 ->b
    #     end
    #     check2 =
    #     cond do
    #       Enum.count(c)==3 -> c
    #       Enum.count(d)==3 ->d
    #     end
    #   rank =[getHighestRank(check1,[]),getHighestRank(check2,[])]
    #   high = getHighestRank(rank,[])
    #   if high in check1 do
    #     IO.puts(check1|> inspect(charlists: :as_lists))
    #   else
    #     IO.puts(check2|> inspect(charlists: :as_lists))
    #   end
    # end
    # if type == 2 do
    #   check1 =
    #   cond do
    #     Enum.count(a)==2 -> a
    #     Enum.count(b)==2 -> b
    #   end
    #   check2 =
    #   cond do
    #     Enum.count(c)==2 -> c
    #     Enum.count(d)==2 ->d
    #   end
    #   rank =[getHighestRank(check1,[]),getHighestRank(check2,[])]
    #   high = getHighestRank(rank,[])
    #   if high in check1 do
    #     IO.puts(check1)
    #     IO.puts(check1|> inspect(charlists: :as_lists))
    #   else
    #     IO.puts(check2)
    #     IO.puts(check2|> inspect(charlists: :as_lists))
    #   end
    # end
  end

  def tie_flush(hand1,hand2) do
    if getHighestRank(hand1,[]) != getHighestRank(hand2,[]) do
      high = getHighestRank([getHighestRank(hand1,[]), getHighestRank(hand2,[])],[])
      if high in hand1 do
        IO.puts(hand1|> inspect(charlists: :as_lists))
      else
        IO.puts(hand2|> inspect(charlists: :as_lists))
      end
    else
      high = getHighestRank([getHighestRank(hand1,[]), getHighestRank(hand2,[])],[])
      tie_flush(hand1--[high],hand2--[high])
    end
  end

  def tie_flushStraight_helper1(hand1,hand2) do
    if getHighestRank(hand1,[]) != getHighestRank(hand2,[]) do
      high = getHighestRank([getHighestRank(hand1,[]), getHighestRank(hand2,[])],[])
      if high in hand1 do
        hand1
      else
        hand2
      end
    else
      high = getHighestRank([getHighestRank(hand1,[]), getHighestRank(hand2,[])],[])
      tie_flush(hand1--[high],hand2--[high])
    end
  end

  #WE MIGHT NEED THIS BUT NOT SURE.
  # def tie_flushStraight_helper2(hand,result) do
  #   if Enum.member?(hand,hd(result))==false do
  #     false
  #   else
  #     if length(result)==0 or result -- [hd(result)] == [] do
  #       true
  #     else
  #       tie_flushStraight_helper2(hand,result -- [hd(result)])
  #     end
  #   end
  # end

  # parameters should be passed in using hand_to_num
  def tie_flushStraight(hand1,hand2) do
    res = tie_flushStraight_helper1(hand1,hand2)
    IO.puts(res|> inspect(charlists: :as_lists))
  end

  def tie_threeKind(hand1, hand2) do
    lst1 = handToNum(hand1)
    lst1 = Enum.sort(lst1)
    lst1 = Enum.chunk_by(lst1, fn x -> x end)
    lst1 = Enum.sort_by(lst1, &length/1, :desc)

    lst2 = handToNum(hand2)
    lst2 = Enum.sort(lst2)
    lst2 = Enum.chunk_by(lst2, fn x -> x end)
    lst2 = Enum.sort_by(lst2, &length/1, :desc)

    a = hd(hd(lst1))
    b = hd(hd(lst2))

    if a > b do
      hand1
    else
      hand2
    end

  end

  # need to add scenario when ace is the highest
  # def tie_twoPair(hand1, hand2) do
  #   lst1 = handToNum(hand1)
  #   lst1 = Enum.sort(lst1)
  #   lst1 = Enum.chunk_by(lst1, fn x -> x end)
  #   lst1 = Enum.sort_by(lst1, &length/1, :desc)

  #   lst2 = handToNum(hand2)
  #   lst2 = Enum.sort(lst2)
  #   lst2 = Enum.chunk_by(lst2, fn x -> x end)
  #   lst2 = Enum.sort_by(lst2, &length/1, :desc)

  #   a = hd(lst1)
  #   b = hd(tl(lst1))
  #   c = hd((tl(tl(lst1))))
  #   d = hd(lst2)
  #   e = hd(tl(lst2))
  #   f = hd((tl(tl(lst2))))

  #   firstPair1 =
  #   cond do
  #     hd(a) > hd(b) -> hd(a)
  #     hd(b) > hd(a) -> hd(b)
  #   end

  #   secondPair1 =
  #   cond do
  #     hd(a) > hd(b) -> hd(b)
  #     hd(b) > hd(a) -> hd(a)
  #   end

  #   firstPair2 =
  #   cond do
  #     hd(d) > hd(e) -> hd(d)
  #     hd(e) > hd(d) -> hd(e)
  #   end

  #   secondPair2 =
  #   cond do
  #     hd(d) > hd(e) -> hd(e)
  #     hd(e) > hd(d) -> hd(d)
  #   end

  #   cond do
  #     firstPair1 > firstPair2 -> IO.inspect(hand1)
  #     # condition for if first pair is the same
  #     firstPair1 == firstPair2 ->
  #       cond do
  #         secondPair1 > secondPair1 -> IO.inspect(hand1)
  #         # condition for if first and second pair are the same
  #         secondPair1 == secondPair2 ->
  #           if c > f do
  #             IO.inspect(hand1)
  #           else
  #             IO.inspect(hand2)
  #           end
  #         secondPair1 < secondPair2 -> IO.inspect(hand2)
  #       end
  #     firstPair1 < firstPair2 -> IO.inspect(hand2)
  #   end

  # end


  # need to add scenario when ace is the highest
  def tie_onePair(hand1, hand2) do
    lst1 = handToNum(hand1)
    lst1 = Enum.sort(lst1)
    lst1 = Enum.chunk_by(lst1, fn x -> x end)
    lst1 = Enum.sort_by(lst1, &length/1, :desc)

    lst2 = handToNum(hand2)
    lst2 = Enum.sort(lst2)
    lst2 = Enum.chunk_by(lst2, fn x -> x end)
    lst2 = Enum.sort_by(lst2, &length/1, :desc)

    # IO.sinspect(lst1, charlists: :as_lists)
    # IO.inspect(lst2, charlists: :as_lists)

    a = hd(lst1)
    b = hd(tl((tl(tl(lst1)))))
    c = hd(lst2)
    d = hd(tl((tl(tl(lst2)))))

    cond do
      hd(a) > hd(c) -> IO.inspect(hand1)
      # condition for if first pair is the same
      hd(a) == hd(c) ->
        cond do
          # if pairs are the same then get the highest rank in hand
          hd(b) > hd(d) -> IO.inspect(hand1)
          hd(b) < hd(d) -> IO.inspect(hand2)
        end
      hd(a) < hd(c) -> IO.inspect(hand2)
    end
  end

  

  

  # # need to add scenario when ace is the highest
  # def tie_highCard(hand1, hand2) do
  #   firstVal1 = getHighestRank(hand1, [])
  #   secondVal1 = getHighestRank(hand1, [firstVal1])
  #   firstVal2 = getHighestRank(hand2, [])
  #   secondVal2 = getHighestRank(hand1, [firstVal2])

  #   cond do
  #     firstVal1 > firstVal2 -> IO.inspect(hand1)
  #     firstVal1 == firstVal2 ->
  #       cond do
  #         secondVal1 > secondVal2 -> IO.inspect(hand1)
  #         secondVal1 < secondVal2 -> IO.inspect(hand2)
  #       end
  #     firstVal1 < firstVal2 -> IO.inspect(hand2)
  #   end

<<<<<<< HEAD
  #   IO.puts(firstVal1)
  #   IO.puts(secondVal1)
  #   IO.puts(firstVal2)
  #   IO.puts(secondVal2)
=======
    # IO.puts(firstVal1)
    # IO.puts(secondVal1)
    # IO.puts(firstVal2)
    # IO.puts(secondVal2)
>>>>>>> 8cb5c6904adc3de4d519d33e41c49476bb383e9f
    # lst1 = handToNum(hand1)
    # lst1 = Enum.sort(lst1)
    # lst1 = Enum.chunk_by(lst1, fn x -> x end)
    # lst1 = Enum.sort_by(lst1, &length/1, :desc)

    # lst2 = handToNum(hand2)
    # lst2 = Enum.sort(lst2)
    # lst2 = Enum.chunk_by(lst2, fn x -> x end)
    # lst2 = Enum.sort_by(lst2, &length/1, :desc)

    # IO.inspect(lst1, charlists: :as_lists)
    # IO.inspect(lst2, charlists: :as_lists)
  # end
  
  # def helper([],hand1,hand2,_count), do: [hand1,hand2]
  # def helper(lst,hand1,hand2,count)do
  #   if count == 8 or Enum.count(lst)==0 do
  #     [hand1,hand2]
  #     IO.puts("here")
  #   end
  #   if rem(count,2)!=0 do
  #     helper(lst--[hd lst],hand1++[hd lst],hand2,count+1)    
  #   else  
  #     helper(lst--[hd lst],hand1,hand2++[hd lst],count+1)    
  #   end
  # end

  # def deal(lst) do
  #   temp1=[]
  #   temp2=[]
  #   setup = helper(lst,temp1,temp2,0)
  #   hand1 = hd setup 
  #   hand2 = hd tl setup
  #   IO.inspect(hand2)

  # end

end
IO.inspect(Poker.handToNum( [27, 45, 3,  48, 44, 43, 41, 33, 12 ]))
#IO.puts(Poker.getCombo([1,7,7,7,7,3],7,[nil]))
IO.puts(Poker.tie_fullhouse([6,6,6,7,7,1,1],[13,13,13,3,3],2))

# IO.puts(Poker.helper([1, 2, 3, 4, 5, 6, 7, 8,9],[],[],0))

# IO.puts( Poker.deal([1, 2, 3, 4, 5, 6, 7, 8,9]))
# IO.puts(Enum.member?(1..10,5))
# IO.puts(Poker.checkNum(28))
# IO.puts(Poker.getHighestRank([1,2,3,4,5],[6]))
#IO.puts(Poker.fullHouse([10, 10, 10, 14, 14,3,3]))
# IO.puts(Poker.fullHouse([10,23,33,1,14]))
# IO.puts(Poker.sameSuit([5,6,7,8,9]))
#  IO.puts(Poker.straightFlush([1,4,3,2,5]))
# IO.puts(Poker.fourOfAKind([14, 15, 16, 17, 1]))
# IO.puts(Poker.threeOfAKind([11, 11, 11, 17, 4]))
# IO.puts(Poker.twoPair([14, 14, 16, 16, 1]))
# IO.puts(Poker.pair([14, 14, 16, 17, 1]))
# IO.puts(Poker.highCard([14, 15, 16, 17, 1]))
#IO.puts(Poker.tie_flushStraight([7,8,6,5,4],[7,10,3,5,4]))
# IO.puts(Poker.finalHand([1,2,3,4,5]))
# IO.inspect(Poker.tie_threeKind([2,15,4,5, 28], [5,31,4,2,18]))
# Poker.tie_twoPair([2,15,4,17,7], [11,24,5,31,7])
# Poker.tie_twoPair([2,15,4,17,7], [28,41,30,43,10])
# Poker.tie_twoPair([2,15,4,17,7], [28,41,5,31,10])

# Poker.tie_onePair([2,15,6,17,7], [26,13,11,31,1])
# Poker.tie_onePair([39,52,6,38,7], [26,13,11,31,1])
#IO.puts(Poker.getHighestRank([1,26,6,31,33],[]))
# IO.puts(Poker.checkSequenceV1([1, 2, 5, 4, 3]))
