# Notes from Going Through this Challenge

### Links

1. github README.md that I found to be the most recent version of this challenge: https://github.com/scaffold-eth/scaffold-eth/tree/loogies-svg-nft
2. Youtube speed run of it: https://twitter.com/austingriffith/status/1433894316737368067?s=20
3. Youtube videos on SVGs (decent background on it if you are new to SVGs in the coding world, which I was): https://www.youtube.com/watch?v=ZJSCl6XEdP8 + https://www.youtube.com/watch?v=9Y4P3FvZ5bg
4. 2021 blog post outlining on-chain SVG artwork created: https://blog.simondlr.com/posts/flavours-of-on-chain-svg-nfts-on-ethereum

### Approach

This challenge hasn't been finalized on eth-dev-speedrun just yet, so I did the following to ensure I understood it well enough:

1. Go through smart contracts and assess each line of code to ensure I understand it (the SVG side of things was the most challenging since I was new to it).
2. Write the code line by line referencing the medium post.
3. Come back to this after a couple of days and write it on your own without looking at the code.
4. Mark down other notes about this to keep in mind.

### Keep in Mind

1. How does the data URI work now with OpenSea? Is it recognized? Dom made a reply tweet back in May 2021 about how it wasn't really recognized yet throughout industry, but the blog post I posted up above outlines how Uniswap made that different. I looked at opensea docs and it doesn't seem to actually outline how to use the DATA URI for on-chain SVG art.

### Lessons

1. on-chain SVG art is pretty cool! You can mint and store, on-chain, the ingredients to generate the art by leveraging the tokenID for that respective NFT and a view function to generate the SVG art on your browser or wherever.
2. It is a bit of a golf-game for gas awareness as you are storing the SVG file on-chain. There are a number of ways to go about this and counting. Taking a look through the blog post in 4. above is a good start to get a gauge on how things are being conducted currently.
