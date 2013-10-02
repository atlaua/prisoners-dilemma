{-# LANGUAGE TupleSections #-}

module Pd.Master 
    ( Score
    , Steps
    , playN
    , play2
    , table
    ) where

import Data.Function (on)
import Data.List (foldl')
import Data.Map.Strict ((!))

import qualified Data.Map.Strict as M

import Pd.Types


type Id = Int
type Score = Int
type Steps = Int


playN :: Steps -> [Agent] -> [Score]
playN steps agents = sumScores $ foldl' playN' buildMap pairs
    where
    sumScores :: M.Map Id (Agent, Score) -> [Score]
    sumScores = map (snd . snd) . M.toAscList

    buildMap :: M.Map Id (Agent, Score)
    buildMap = M.fromList . zip [0..] . zip agents $ repeat 0

    pairs = [(i, j) | i <- [0..n], j <- [i+1..n]]
    n = length agents - 1

    playN' :: M.Map Id (Agent, Score) -> (Id, Id) -> M.Map Id (Agent, Score)
    playN' m (i1, i2) = M.update (addScore s1) i1 $ M.update (addScore s2) i2 m
        where
        (s1, s2) = play2 steps ((getAgent i1), (getAgent i2))
        getAgent = fst . (m !)
        addScore s' = Just . (\(a, s) -> (a, s+s'))


play2 :: Steps -> (Agent, Agent) -> (Score, Score)
play2 = play2' (0, 0) (Init, Init)

play2' :: (Score, Score) -> (Action, Action) -> Steps -> (Agent, Agent) -> (Score, Score)
play2' scores _ 0 _ = scores
play2' scores (action1, action2) n (agent1, agent2) = play2' (scores `addScores` scores')
                                                                 actions
                                                                 (n-1)
                                                                 (nextAgent decision1, nextAgent decision2)
    where
    scores' = table actions
    actions = (action decision1, action decision2)
    decision1 = runAgent agent1 action2
    decision2 = runAgent agent2 action1

addScores :: (Score, Score) -> (Score, Score) -> (Score, Score)
addScores (s1a, s2a) (s1b, s2b) = (s1a+s1b, s2a+s2b)


table :: (Action, Action) -> (Score, Score)
table (Cooperate, Cooperate) = (2, 2)
table (Cooperate, Defect   ) = (0, 3)
table (Defect,    Cooperate) = (3, 0)
table (Defect,    Defect   ) = (1, 1)
