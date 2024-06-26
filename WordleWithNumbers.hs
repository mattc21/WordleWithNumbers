{-# LANGUAGE CPP #-}

module WordleWithNumbers
    ( solve
    ) where

{--

Game description

The computer will generate a random sequence of N numbers, where N is a number between 1 and 1000, inclusive.
Each number in the sequence is in the range [0..9]. Your task is to guess the sequence.
To play the game, you will need to implement an IO function called `solve`
that interacts with the standard input-output (terminal) and guesses the sequence.

Each round of the game proceeds as follows:
    1. You input a sequence into the terminal.
    2. The computer outputs a tuple of two lists of integers, (strongMatch, weakMatch).
    -  strongMatch is a list of positions (0-based) in your guess where you guessed both the number and its position correctly.
    -  weakMatch is a list of positions (0-based) in your guess where you guessed the number correctly, but its position is wrong.

For example, suppose the computer generated a sequence of 5 numbers: [9, 3, 5, 5, 1].
If your guess is [1, 2, 3, 4, 5], the computer will output ([], [0, 2, 4]), indicating that there are no numbers in the correct positions,
but the numbers 1, 3, and 5 are present in both sequences.

If your guess is [2, 3, 4, 5, 5], the computer will output ([1, 3], [4]), indicating that you correctly guessed the numbers in positions 1 and 3,
and also correctly guessed the number 5, but in the wrong position.

If you guess the sequence, the computer will output ([0, 1, 2, ..., N-1], []) and the game will end.

If the length of your guess does not match the length of the sequence, or any of the numbers in your guess are out of range [0..9],
the computer will output ([-1], [-1]).

Your task is to implement an IO function which will interact with the standard input-output (terminal) and guess the sequence.

		solve :: IO ()

When called, solve should do the following:
    1. Read an integer N from the terminal, indicating the length of the sequence to be guessed.
    2. In each round of the game, output a sequence of N numbers, each in the range [0..9],
       and read the computer's response (a tuple of two lists of integers).
    3. Repeat step 2 until the sequence is guessed (i.e., until the computer's response is ([0, 1, 2, ..., N-1], [])).

A possible interaction might look like this:
Suppose the computer created a sequence of 5 numbers: [9, 3, 5, 5, 1].
Lines with ODD numbers will represent computer output which your function should read from the standard input.
The other lines should be printed by solve.
N> represents the line with number N. "N>" is not a part of the input-output.

> solve
1> 5
2> [1, 2, 3, 4, 5]
3> ([], [0, 2, 4])
4> [1, 1, 1, 1, 1]
5> ([4], [])
6> [5, 4, 3, 2, 1]
7> ([4], [0, 2])
8> [5, 5, 1, 3, 9]
9> ([], [0, 1, 2, 3, 4])
10> [1, 2, 4]
11> ([-1], [-1])
12> [10, 3, 5, 5 ,1]
13> ([-1], [-1])
14> [9, 3, 5, 5, 1]
15> ([0, 1, 2, 3, 4], [])

--}

solve :: IO ()
solve = do
    len <- readLn :: IO Int
    let known = take len $ repeat (-1)
    solveLoop 0 known

solveLoop :: Int -> [Int] -> IO ()
solveLoop num known = do
    let guess = createGuess num known
    print guess
    (results, _) <- readLn :: IO ([Int], [Int])
    if length results == length known then
        do
            return ()
    else
        do
            let newKnown = modifyKnown guess results known
            solveLoop (num+1) newKnown


createGuess :: Int -> [Int] -> [Int]
createGuess num [] = []
createGuess num (x:xs) = val : createGuess num xs
    where
        val 
            | x == -1 = num
            | otherwise = x

modifyKnown :: [Int] -> [Int] -> [Int] -> [Int]
modifyKnown _ [] known = known
modifyKnown guess (x:xs) known = modifyKnown guess xs (replaceElement known x (guess!!x))


replaceElement :: [a] -> Int -> a -> [a]
replaceElement list index val = p1 ++ [val] ++ p2
    where
        (p1, _:p2) = splitAt index list
