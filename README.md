Prisoners Dilemma Simulator
===========================

This is a simple [Prisoners' Dilemma][wiki PD] simulator, written in Haskell and published under the MIT license.


Overview
--------

- *Pd.Master* includes the main game logic. Its interface consists of *play2*, which simulates an iterated prisoners'
  dilemma with two agents, and *playN*, which takes `n` agents and simulates the same for each possible pair, summing up
  the scores.

- *Pd.Agents* has some example agents, namely *Always Cooperate*, *Always Defect* and *Tit for Tat*.


Usage
-----

So far, there is no user interface, you'll have to use *ghci*:

    λ> :l Pd/Main.hs 
    [1 of 4] Compiling Pd.Types         ( Pd/Types.hs, interpreted )
    [2 of 4] Compiling Pd.Master        ( Pd/Master.hs, interpreted )
    [3 of 4] Compiling Pd.Agents        ( Pd/Agents.hs, interpreted )
    [4 of 4] Compiling Main             ( Pd/Main.hs, interpreted )
    Ok, modules loaded: Pd.Agents, Pd.Master, Main, Pd.Types.
    λ> play2 1 (alwaysD, alwaysD)
    (1,1)
    λ> play2 1 (alwaysD, alwaysC)
    (3,0)
    λ> play2 10 (alwaysD, alwaysC)
    (30,0)
    λ> playN 1 [alwaysD, alwaysD]
    [1,1]
    λ> playN 1 [alwaysD, alwaysC, titForThat]
    [6,2,2]
    λ> playN 10 [alwaysD, alwaysC, titForThat]
    [42,20,29]


Todo
----

- Allow alternative payoff matrices.
- Hide the plumbing, create a proper interface.



[wiki PD]: https://en.wikipedia.org/wiki/Prisoner%27s_dilemma "Wikipedia article on the Prisoners' dilemma"
