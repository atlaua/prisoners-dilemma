module Pd.Agents 
    ( alwaysC
    , alwaysD
    , titForThat
    ) where

import Pd.Types


type StatelessAgent = Action -> Action

statelessAgent :: StatelessAgent -> Agent
statelessAgent ag = Agent $ \act-> Decision (statelessAgent ag) (ag act)


alwaysC :: Agent
alwaysC = statelessAgent $ const Cooperate


alwaysD :: Agent
alwaysD = statelessAgent $ const Defect


titForThat :: Agent
titForThat = statelessAgent titForThat'

titForThat' :: StatelessAgent
titForThat' Init = Cooperate
titForThat' a = a
