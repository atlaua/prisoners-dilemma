module Pd.Agents.Examples
    ( alwaysC
    , alwaysD
    , titForThat
    ) where

import Pd.Agents.Core


alwaysC :: Agent
alwaysC = statelessAgent $ const Cooperate


alwaysD :: Agent
alwaysD = statelessAgent $ const Defect


titForThat :: Agent
titForThat = statelessAgent titForThat'

titForThat' :: StatelessAgent
titForThat' Init = Cooperate
titForThat' a = a
