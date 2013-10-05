module Pd.Agents.Core where


data Action = Cooperate | Defect deriving Show
newtype Agent = Agent {runAgent :: Maybe Action -> (Agent, Action)}

nextAgent = fst
action = snd


type StatelessAgent = Maybe Action -> Action

statelessAgent :: StatelessAgent -> Agent
statelessAgent ag = Agent $ \act-> (statelessAgent ag, ag act)
