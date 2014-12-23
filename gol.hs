module Main where

import Graphics.QML
import Control.Concurrent
import Control.Exception
import Data.IORef
import Data.Text (Text)
import qualified Data.Text as T

-- ===================================
-- Definitions
-- ===================================

width :: Int
width = 20
height :: Int
height = 20
lastCell :: Int
lastCell = width * height

type Pos = (Int, Int)
type Board = [Pos]

glider :: Board
glider = [(4,2),(2,3),(4,3),(3,4),(4,4)]

-- ===================================
-- Main function & methods for HsQML
-- ===================================

main :: IO ()
main = do
    state <- newIORef $ boardToList 0 glider
    skey <- newSignalKey
    clazz <- newClass [
        defPropertySigRW' "result" skey (\_ -> readIORef state) 
            (\obj newState -> do
                writeIORef state newState
                fireSignal skey obj),
        defMethod' "nextStep" (\obj -> do
            let signal = fireSignal skey obj
            nextState state signal
            return ()),
        defMethod' "reset" (\obj -> do
            let signal = fireSignal skey obj
            resetState state signal
            return ())]
    ctx <- newObject clazz ()
    runEngineLoop defaultEngineConfig {
        initialDocument = fileDocument "gol.qml",
        contextObject = Just $ anyObjRef ctx}

-- ===================================
-- Functions triggered from UI
-- ===================================

nextState :: IORef [Bool] -> IO () -> IO ThreadId
nextState state signal = 
    forkIO $ do
        currentState <- readIORef state
        let out = boardToList 0 (nextGen (listToBoard 0 currentState))
        evaluate out
        writeIORef state out
        signal
        
resetState :: IORef [Bool] -> IO () -> IO ThreadId
resetState state signal = 
    forkIO $ do
        let out = boardToList 0 glider
        evaluate out
        writeIORef state out
        signal

-- ===================================
-- Helpers
-- ===================================
        
getIndex :: Pos -> Int
getIndex (x,y) = y*width+x

getPos :: Int -> Pos
getPos i = (x,y) where 
                x = i `mod` width
                y = i `div` width

boardToList :: Int -> [Pos] -> [Bool]
boardToList i b
            | i >= lastCell = []
            | elem p b = True : boardToList (i+1) (filter (/= p) b)
            | otherwise = False : boardToList (i+1) b
            where p = (getPos i)

listToBoard :: Int -> [Bool] -> Board
listToBoard i [] = []
listToBoard i (b:bs)
            | b == True = (getPos i) : listToBoard (i+1) bs
            | otherwise = listToBoard (i+1) bs

-- ===================================
-- Game of life implementation
-- ===================================            
            
isAlive :: Board -> Pos -> Bool
isAlive b p = elem p b

isEmpty :: Board -> Pos -> Bool
isEmpty b p = not (isAlive b p)

neighbs :: Pos -> [Pos]
neighbs (x,y) = map wrap [(x-1, y-1), (x, y-1), (x+1, y-1), 
                    (x-1, y), (x+1, y),
                    (x-1, y+1), (x, y+1), (x+1, y+1)]

wrap :: Pos -> Pos
wrap (x,y) = (x `mod` width, y `mod` height)

liveNeighbs :: Board -> Pos -> Int
liveNeighbs b  = length . filter (isAlive b) . neighbs

survivors :: Board -> [Pos]
survivors b = [p | p <- b, elem (liveNeighbs b p) [2,3]]

births :: Board -> [Pos]
births b = [p | p <- rmdups (concat (map neighbs b)),
                isEmpty b p,
                liveNeighbs b p == 3]

rmdups :: Eq a => [a] -> [a]
rmdups [] = []
rmdups (x:xs) = x : rmdups (filter (/= x) xs)

nextGen :: Board -> Board
nextGen b = survivors b ++ births b