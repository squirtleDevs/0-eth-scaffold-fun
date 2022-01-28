# Notes

This is a breakdown of the smart contracts that make up CRYPTOGS.

High-Level Blurb Explaining the Mechanics:

---

## Austin's original information about the project:

# Cryptogs

[<img src="https://cryptogs.io/screen.jpg">](https://cryptogs.io)

We extended the ERC-721 token standard to include the game of pogs!

All interactions happen on-chain including a commit/reveal scheme for randomness.

Purchase a pack of pogs for basically the gas it cost to mint them and come play with the rest of the decentralized world.

[It's SLAMMER TIME on the blockchain!](https://cryptogs.io)

[<img src="https://cryptogs.io/screens/slam.gif">](https://cryptogs.io)

---

## My Extra Notes

SlammerTime.sol and Cryptogs.sol were the core contracts. See the reference folder for commented out code (comments made in 2022 by our team). The OG project was created during an EthDenver hackathon by Austin Griffith and his team, and this "reborn" Cryptogs project has been relaunched for EthDenver 2022!

## Contract Break-Down (High Level)

GAMEPLAY:

- Two users present their stack of Cryptogs for game.

First tx:

- First user preps their stack and presents it, calling the function submitStack(). This function approves the SlammerTime contract to take these tokens. Event triggered is broadcast to players showing an open challenge.
  - require(owner[token]=msg.sender);
  - require(approve(slammerTime(<correctToken>)))
  - Generate stack (hash of nonce of this contract? and msg.sender address)
  - Creates a Stack struct with the Cryptogs chosen (stored in memory as an array), with the block.number of the tx.
  - Stores the Stack struct into stacks mapping which is a (bytes32 => Struct) mapping.
  - SubmitStack() is the event that is broadcast for challengers containing: msg.sender, time of challenge (now), bytes32 stack, cryptogs ids, and whether the game is public or private)

Second tx:

- Player approves SlammerTime contract to take their tokens.
- Triggers an event broadcasted to player one of player 2's intent to rumble!
- TODO: not sure what `_id` is
- Creates a Stack struct just like tx1 but for player2.
- Populates stackCounter mapping(bytes32 => bytes32) with the bytes32 \_stack from player 1. This stores the actual game players and the nonces that they were each accepted.

TODO: there is a comment about cleaning up their stack if the user created their stack... not sure what this means and is referring to. The comment went on to say that the timeout in the frontend will help solve this but it is still something to be solved.

Optional txs:

cancelStack(bytes32 \_stack)

- requires that mode[_stack] == 0; TODO: not sure what mode is, but I think it is a boolean representing the state of the game. If it is 0 than it has not started (accepted by player1)
- Make sure that it is not a counterStack[], I guess if it is... then that's just the counterStack backing out of the game, player 1 should not have to redeploy the initial challenge.
- deletes the mapping stacks[_stack] so it is no longer an open challenge.

cancelCounterStack()

- kind of self explanatory
  TODO: expalin it though

acceptCounterStack()

-
-

- FLIPPINESS:

- BONUS:

### Future Ideas:

- Add a way to directly challenge a specific user, or if a challenge is open, have a way to specify the single user so no one else can just spam you with challenges --> a bit of front end and smart contract work to showcase the right address as the challenger.
