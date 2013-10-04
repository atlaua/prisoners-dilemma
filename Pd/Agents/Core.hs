module Pd.Agents.Core where


data Action = Cooperate | Defect | Init deriving Show
newtype Agent = Agent {runAgent :: Action -> (Agent, Action)}

nextAgent = fst
action = snd


type StatelessAgent = Action -> Action

statelessAgent :: StatelessAgent -> Agent
statelessAgent ag = Agent $ \act-> (statelessAgent ag, ag act)
