{-# OPTIONS_GHC -Wno-unused-imports   #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}

-- |
-- Module      : AOC.Challenge.Day01
-- License     : BSD3
--
-- Stability   : experimental
-- Portability : non-portable
--
-- Day 1.  See "AOC.Solver" for the types used in this module!
--
-- After completing the challenge, it is recommended to:
--
-- *   Replace "AOC.Prelude" imports to specific modules (with explicit
--     imports) for readability.
-- *   Remove the @-Wno-unused-imports@ and @-Wno-unused-top-binds@
--     pragmas.
-- *   Replace the partial type signatures underscores in the solution
--     types @_ :~> _@ with the actual types of inputs and outputs of the
--     solution.  You can delete the type signatures completely and GHC
--     will recommend what should go in place of the underscores.

module AOC.Challenge.Day01 (
  day01a,
  day01b
  ) where

import           AOC.Prelude
import Data.List (isPrefixOf)

extractNum :: String -> Int
extractNum line = read num
  where
    nums = filter isDigit line
    num = head nums : [last nums]

solve1a :: [String] -> Int
solve1a items = sum $ map extractNum items

day01a :: _ :~> _
day01a = MkSol
    { sParse = Just . lines
    , sShow  = show
    , sSolve = Just . solve1a
    }

day01b :: _ :~> _
day01b = MkSol
    { sParse = Just . lines
    , sShow  = show
    , sSolve = Just . solve1b
    }

digitsNums :: [(String, Int)]
digitsNums = zip digits nums
  where digits = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
        nums = [0..9]

test :: IO ()
test = putStrLn "wat"

solve1b :: [String] -> Int
solve1b items = sum $ map (getFirstLast . extractNums []) items

getFirstLast :: [Int] -> Int
getFirstLast nums = read $ show (head nums) ++ show (last nums)

extractNums :: [Int] -> String -> [Int]
extractNums prev "" = prev
extractNums prev str = case extractMatch str of
    Just (newStr, newInt) -> extractNums (prev ++ [newInt]) newStr
    Nothing -> extractNums prev (tail str)
    where
      maybeStringMatchs :: String -> Maybe (String, Int)
      maybeStringMatchs str = firstJust (maybeStringMatch str) digitsNums
      maybeStringMatch :: String -> (String, Int) -> Maybe (String, Int)
      maybeStringMatch str (prefix, prefixNum) =
        if prefix `isPrefixOf` str
        then Just (drop (length prefix) str, prefixNum)
        else Nothing
      maybeDigitMatch :: String -> Maybe (String, Int)
      maybeDigitMatch digitStr = if isDigit (head digitStr) then Just (tail str, read [head digitStr]) else Nothing
      extractMatch :: String -> Maybe (String, Int)
      extractMatch str = maybeStringMatchs str <|> maybeDigitMatch str