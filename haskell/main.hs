import System.Environment
import System.IO
import Data.List
import Data.Array

type Position = (Int, Int)

getNeighbors :: Position -> [Position]
getNeighbors (row, col) = [
    (row-1, col-1),
    (row-1, col  ),
    (row-1, col+1),

    (row  , col-1),
    (row  , col+1),

    (row+1, col-1),
    (row+1, col  ),
    (row+1, col+1)]

frequency :: Ord a => [a] -> [(Int, a)] 
frequency list = map (\l -> (length l, head l)) (group (sort list))

first (f, _) = f


listOfOnes :: [Char] -> Int -> Int -> [Position]
listOfOnes [] _ _ = []
listOfOnes (c:cs) row col
    | c == '\n' = listOfOnes cs (row+1) 0
    | c == '1'  = (row, col) : listOfOnes cs row (col+1) 
    | otherwise = listOfOnes cs row (col+1)

filterTheGood :: [Position] -> [(Int, Position)] -> [Position]
filterTheGood _ [] = []
filterTheGood old ((rep, pos):poss)
    | pos `elem` old = if rep == 3 || rep == 2
                        then pos:rest
                        else rest

    | otherwise =
        if rep == 3
            then pos:rest
            else rest

    where rest = filterTheGood old poss

createArr :: Int -> Position -> [Position] -> [Char]
createArr maxCol (lastRow, lastCol) []
    | lastRow <= maxCol = rep (maxCol - lastCol) ++ '\n' : createArr maxCol (lastRow+1, 0) []
    | otherwise         = []
    where rep n = replicate n '-'

createArr maxCol (lastRow, lastCol) ((row, col):poss)
    | row == lastRow =
        rep (col - lastCol - 1) ++ '1' : createArr maxCol (row, col) poss
    | otherwise =
        rep (maxCol - lastCol) ++ '\n' : createArr maxCol (row, -1) ((row, col):poss) 

    where rep n = replicate n '-'

main = do
    --[f, g] <- getArgs
    --let inPath = "in.txt"
    --let outPath = "out.txt"
    inHandle <- openFile "in.txt" ReadMode
    
    inData <- hGetContents inHandle 
    let listOfAlive = listOfOnes inData 0 0

    let nextIt = map getNeighbors listOfAlive
    let nextItFlat = foldl (++) [] nextIt

    let newAlive = filterTheGood listOfAlive (frequency nextItFlat)


    putStrLn $ show listOfAlive
    putStrLn $ show $ newAlive

    let maxCol = 20
    let maxRow = 5


    writeFile "out.txt" (createArr maxCol (0, 0) newAlive)

    hClose inHandle