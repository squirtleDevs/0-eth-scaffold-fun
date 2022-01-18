Use this MVP DEX article to create a smart contract that will swap tokens and ETH: https://medium.com/@austin_48503/%EF%B8%8F-minimum-viable-exchange-d84f30bd0c90

PRO TIP, use a master branch of 🏗 scaffold-eth so you have all the latest goodies: https://github.com/scaffold-eth/scaffold-eth

---

# Notes from Going Through this Challenge

### Links

1. Medium post: https://medium.com/@austin_48503/%EF%B8%8F-minimum-viable-exchange-d84f30bd0c90
2. github README.md that I found to be the most recent version of this challenge: https://github.com/scaffold-eth/scaffold-eth-challenges/tree/challenge-5-dex
3. Youtube speed run of it: https://www.youtube.com/watch?v=eP5w6Ger1EQ&t=364s&ab_channel=SimplyExplained

### Approach

This challenge hasn't been finalized on eth-dev-speedrun just yet, so I did the following to ensure I understood it well enough:

1. Go through medium post and assess each line of code to ensure I understand it (the math side was the most challenging part of this, but if you understand TWAP from Uniswap you'll be able to understand this IMO!).
2. Write the code line by line referencing the medium post.
3. Come back to this after a couple of days and write it on your own without looking at the code.
4. Mark down other notes about this to keep in mind.

### Keep in Mind

1. The front-end aspects were not working just yet due to a bug that needed to be fixed with `AddressInput` on the react side with importing from eth-hooks. So gotta go back and start working with that once I start working on React more.
2. The math side is important to come back to with a pen and paper to make sense of.
