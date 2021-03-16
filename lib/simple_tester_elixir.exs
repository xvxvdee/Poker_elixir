
cards = [ "1C", "2C", "3C", "4C", "5C", "6C", "7C", "8C", "9C", "10C", "11C", "12C", "13C",
		  "1D", "2D", "3D", "4D", "5D", "6D", "7D", "8D", "9D", "10D", "11D", "12D", "13D",
		  "1H", "2H", "3H", "4H", "5H", "6H", "7H", "8H", "9H", "10H", "11H", "12H", "13H",
	      "1S", "2S", "3S", "4S", "5S", "6S", "7S", "8S", "9S", "10S", "11S", "12S", "13S"
        ]

perms = [ [ 9,  8,  7,  6,  5,  4,  3,  2,  1  ],  # 1   2-6 Straight flush VS 1-5 straight flush
          [ 40, 41, 42, 43, 48, 49, 50, 51, 52 ],  # 2   Royal flush VS straight flush
          [ 40, 41, 27, 28, 1,  14, 15, 42, 29 ],  # 3   Four aces VS 2-full-of-A
          [ 30, 13, 27, 44, 12, 17, 33, 41, 43 ],  # 4   3-fours VS 2-fours
          [ 27, 45, 3,  48, 44, 43, 41, 33, 12 ],  # 5   Flush VS straight
          [ 17, 31, 30, 51, 44, 43, 41, 33, 12 ],  # 6   3-fours VS 2-queens-2-fives
          [ 17, 39, 30, 52, 44, 25, 41, 51, 12 ],  # 7   Q-full-of-K VS Q-full-of-4
          [ 11, 25, 9,  39, 50, 48, 3,  49, 45 ],  # 8   9-K straight VS 9-J-two-pair
          [ 50, 26, 39, 3,  11, 27, 20, 48, 52 ],  # 9   J-K-two-pair VS K-pair
          [ 40, 52, 46, 11, 48, 27, 29, 32, 37 ],  # 10  A-pair VS J-pair
          # other tests
          [ 6,  15, 45, 28,  2, 19, 32, 29, 41 ],  # 11  4-sixes VS 4-twos GOOD
          [ 1,  52, 44, 21, 39, 14, 36, 10, 23 ],  # 12  Both Full House with 2-A VS 2-K GOOD
          [ 6,  13,  1,  7,  2,  3,  8, 10, 11 ],  # 13  Both Flush with A high VS K high ** error with higherTopCard
          [ 11, 10,  9,  7,  2,  6,  8, 13,  3 ],  # 14  Both Flush with 10 high VS 11 high ** error with higherTopCard
          [ 13, 38,  3, 28,  1, 23, 47,  6, 18 ],  # 15  Highest card in player hand 13 ** returns 1C
          [ 14, 43,  9, 12, 38, 47, 36, 37, 26 ],  # 16  Royal flush VS straight flush
          [ 37, 13, 38, 29, 24, 16, 31, 34, 35 ],  # 17  flush vs 2-J **
          [ 38, 36, 37, 29, 24, 34, 31, 35, 16 ],  # 18  Both flush with 10 high vs Q high within flush **
          [ 52, 30, 39, 17, 25, 12, 51, 41, 44 ],  # 19  Both FH with one 4 high and another K high in the pair part GOOD
        ]

sols  = [ [ "2C",  "3C",  "4C",  "5C",  "6C"  ],   # 1   2-6 Straight flush
          [ "10S", "11S", "12S", "13S", "1S"  ],   # 2   Royal flush
          [ "1C",  "1D",  "1H",  "1S"         ],   # 3   Four aces
          [ "4D",  "4H",  "4S"                ],   # 4   3-fours
          [ "2S",  "4S",  "5S",  "6S",  "9S"  ],   # 5   Flush
          [ "4D",  "4H",  "4S"                ],   # 6   3-fours
          [ "12C", "12D", "12S", "13H", "13S" ],   # 7   Q-full-of-K
          [ "10S", "11S", "12D", "13H", "9S"  ],   # 8   9-K straight
          [ "11C", "11S", "13H", "13S"        ],   # 9   J-K-two-pair
          [ "1H",  "1S"                       ],   # 10  A-pair

          # other tests
          [ "6S",  "6C",  "6H",  "6D"         ],   # 11  4-sixes
          [ "1C",  "1D",  "10D", "10C", "10H" ],   # 12  Full House with 3-tens and 2-A
          [ "1C",  "11C", "10C", "8C",  "6C"  ],   # 13  Flush with A high
          [ "13C", "11C", "9C",  "8C",  "6C"  ],   # 14  Flush with 11 high
          [ "13C"                             ],   # 15  13 high
          [ "1D",  "13D", "12H", "11H", "10H" ],   # 16  Royal flush -- I THINK THIS IS WRONG
          [ "12H", "11H", "9H",  "8H",  "5H"  ],   # 17  flush with Q-high
          [ "12H", "11H", "9H",  "8H",  "5H"  ],   # 18  Flush with Q-high
          [ "13H", "13S", "12S", "12C", "12D" ],   # 19  FH with 13 high in the part part
        ]

allScores = for test <- 0..(length(perms)-1) do

    input = Enum.at(perms, test)
    deal = for id <- input do Enum.at(cards, id-1) end

    try do
        youSaid = Poker.deal(input)
        shouldBe = Enum.sort(Enum.at(sols, test))
        common = Enum.sort(youSaid -- (youSaid -- shouldBe))

		cond do
			length(youSaid) > 5 ->
				IO.puts "Test #{test+1} DISCREPANCY: " <> inspect(input)
				IO.puts "  P1:   " <> inspect([Enum.at(deal, 0), Enum.at(deal, 2)])
				IO.puts "  P2:   " <> inspect([Enum.at(deal, 1), Enum.at(deal, 3)])
				IO.puts "  Pool: " <> inspect(Enum.drop(deal, 4))
				IO.puts "  You returned:   " <> inspect(youSaid)
				IO.puts "  Returned more than five cards! Test FAILED!"
				0
			common == shouldBe ->
				c = length(common)
				IO.puts "Test #{test+1} FULL MARKS  (#{c} of #{c} cards correct)"
				1
            true ->
				IO.puts "Test #{test+1} DISCREPANCY: " <> inspect(input)
				IO.puts "  P1:   " <> inspect([Enum.at(deal, 0), Enum.at(deal, 2)])
				IO.puts "  P2:   " <> inspect([Enum.at(deal, 1), Enum.at(deal, 3)])
				IO.puts "  Pool: " <> inspect(Enum.drop(deal, 4))
				IO.puts "  You returned:   " <> inspect(youSaid)
				IO.puts "  Should contain: " <> inspect(shouldBe)
				IO.puts "  #{length common} of #{length shouldBe} cards correct"
				length(common) / length(shouldBe)
		end
    rescue
        _ ->
            IO.puts "Test #{test+1} ERROR - Runtime error on input " <> inspect(input); 0
    end
end

allScores = List.flatten(allScores)
scorePct = 100*Enum.sum(allScores) / length(allScores)
IO.puts "\nTotal score: #{scorePct}%  (#{Enum.sum allScores}/#{length allScores} points)"
