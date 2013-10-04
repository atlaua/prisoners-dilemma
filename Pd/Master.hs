{-# LANGUAGE TupleSections #-}

module Pd.Master 
    ( Score
    , Steps
    , playN
    , play2
    , table
    ) where

import Control.Arrow (second)
import Data.Function (on)
import Data.List (foldl')
import Data.Map.Strict ((!))

import qualified Data.Map.Strict as M

import Pd.Agents.Core


type Id = Int
type Score = Int
type Steps = Int


playN :: Steps -> [Agent] -> [Score]
playN steps agents = sumScores $ foldl' playN' buildMap pairs
    where
    sumScores :: M.Map Id (Agent, Score) -> [Score]
    sumScores = map (snd . snd) . M.toAscList

    buildMap :: M.Map Id (Agent, Score)
    buildMap = M.fromDistinctAscList . zip [0..] . zip agents $ repeat 0

    pairs = [(i, j) | i <- [0..n], j <- [i+1..n]]
    n = length agents - 1

    playN' :: M.Map Id (Agent, Score) -> (Id, Id) -> M.Map Id (Agent, Score)
    playN' m (i1, i2) = M.adjust (addScore s1) i1 $ M.adjust (addScore s2) i2 m
        where
        (s1, s2) = play2 steps (getAgent i1, getAgent i2)
        getAgent = fst . (m !)
        addScore s' = second (+s')


play2 :: Steps -> (Agent, Agent) -> (Score, Score)
play2 steps agents = extractScores $ iterate play2' (agents, (0, 0), (Init, Init)) !! steps
    where
    extractScores (_, s, _) = s

play2' :: ((Agent, Agent), (Score, Score), (Action, Action)) -> ((Agent, Agent), (Score, Score), (Action, Action))
play2' ((agent1, agent2), scores, (action1, action2)) = (agents', scores', actions')
    where
    agents' = (nextAgent decision1, nextAgent decision2)
    scores' = scores `addScores` table actions'
    actions' = (action decision1, action decision2)

    decision1 = runAgent agent1 action2
    decision2 = runAgent agent2 action1

    addScores (s1a, s2a) (s1b, s2b) = (s1a+s1b, s2a+s2b)


table :: (Action, Action) -> (Score, Score)
table (Cooperate, Cooperate) = (2, 2)
table (Cooperate, Defect   ) = (0, 3)
table (Defect,    Cooperate) = (3, 0)
table (Defect,    Defect   ) = (1, 1)
