# Solution - Homework 1

> Discuss in your teams what a decentralised version of a game like monopoly would be like, if there was no software on a central server.
>
> Consider:
> - What are the essential pieces of functionality ?
> - How would people cheat ?
> - How could you prevent them from cheating ?

Monopoly is a game that contains a global state, shared among all players. Additionally, each player rolls a dice once per turn, and that may trigger an action (e.g. pay rent, buy a property, etc.).

The key here is to find ways to keep people from cheating. We can encode cheating as an "invalid state", i.e. a state which could not be reached without breaking the rules of the game. This also means that the action(s) that led to this invalid state are not accepted by the remaining players. In other words, "consensus" has not been reached.

## Essential functionality

We need the following essential ingredients:
- Global state of the game publicly visible to all participants (e.g. database)
- Mechanism (e.g. server) that receives requests from players with their move
- Random dice 

## How could people cheat?

People could in theory cheat by submitting illegal transactions. For example:
1. I could use a fake dice that gives me a given result, allowing me to land at a particular spot.
2. I could submit an illegal transaction, e.g. I buy a given house at spot 10 although I should not be able to do that at that particular spot.

## Keep people from cheating

Addressing the points above:

1. The dice rolling mechanism can be either a. done by a trusted party or b. in a decentralized- and pseudo-random way (e.g. leveraging block heights, system times, etc), instead of letting the user roll a dice privately.

2. There should be a way to verify transactions before submitting them to the global state. We could either a. let other players validate transactions ("validators") and reward them for it or b. have this validation be carried out by a centralized trusted third-party that simply rejects illegal transactions.
