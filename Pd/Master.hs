{-# LANGUAGE TupleSections #-}

module Pd.Master 
    ( Score
    , Steps
    , playN
    , play2
    , table
    ) where

import Data.Function (on)
import Data.List (groupBy, sort, tails)

import Pd.Types


type AgentId = Int
type IdAgent = (AgentId, Agent)
type IdScore = (AgentId, Score)
type Score = Int
type Steps = Int


playN :: Steps -> [Agent] -> [Score]
playN n = sumScores . playN' n . genPairs

sumScores :: [IdScore] -> [Score]
sumScores = map snd . map reduce . groupBy ((==) `on` fst) . sort
    where
    reduce x = (fst $ head x, sum $ map snd x)

playN' :: Steps -> [(IdAgent, IdAgent)] -> [IdScore]
playN' n = concat . map mapper
    where
    mapper ((i1, a1), (i2, a2)) = [(i1, s1), (i2, s2)]
        where
        (s1, s2) = play2 n (a1, a2)

genPairs :: [Agent] -> [(IdAgent, IdAgent)]
genPairs agents = concat $ [map (x,) xs | (x:xs) <- init . tails $ zip [0..] agents]


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
    decision1 = (runAgent agent1) action2
    decision2 = (runAgent agent2) action1

addScores :: (Score, Score) -> (Score, Score) -> (Score, Score)
addScores (s1a, s2a) (s1b, s2b) = (s1a+s1b, s2a+s2b)


table :: (Action, Action) -> (Score, Score)
table (Cooperate, Cooperate) = (2, 2)
table (Cooperate, Defect   ) = (0, 3)
table (Defect,    Cooperate) = (3, 0)
table (Defect,    Defect   ) = (1, 1)
