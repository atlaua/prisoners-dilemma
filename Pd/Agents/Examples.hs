module Pd.Agents.Examples
    ( alwaysC
    , alwaysD
    , titForThat
    ) where

import Data.Maybe (fromMaybe)

import Pd.Agents.Core


alwaysC :: Agent
alwaysC = statelessAgent $ const Cooperate


alwaysD :: Agent
alwaysD = statelessAgent $ const Defect


titForThat :: Agent
titForThat = statelessAgent $ fromMaybe Cooperate
