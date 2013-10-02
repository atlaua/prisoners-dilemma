module Pd.Types 
    ( Action(..)
    , Agent(..)
    , Decision(..)
    ) where


data Action = Cooperate | Defect | Init deriving Show

data Decision = Decision {nextAgent :: Agent, action :: Action}
newtype Agent = Agent {runAgent :: Action -> Decision}
