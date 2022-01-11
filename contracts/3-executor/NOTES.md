##

> From Austin Griffith's tweetstorm: "A quick jumping off point is building an "executor" smart contract that just .calls() anything the owner sends it.
> This will test your knowledge of calldata and you should go all the way to mainnet with it."

## Clean Thoughts on How to Carry Out Challenge

> 1. Set up `executor.sol` contract with a `calls(bytes32 data)` function that carries out the function call associated to `data`.
> 2. Set up another contract `caller.sol` that has a function that passes calldata to `calls()` within `executor.sol`.
> 3. Go through the numerous test cases to see how the EVM will respond once the code is compiled and you attempt to interact with it as a user within debug tab.
> 4. Test case 1: see what happens when you attempt to carry out the global functions: `send()`, `transfer()`, `call()`
> 5. Test case 2: see what happens when you attempt to encode a custom function in a different contract. Contract #3: `test.sol` Let's say, `sum() public returns (uint256)` where there are local variables in `sum`: uint256 sum = 7+35; returns sum; --> Within `caller.sol`, write a new function `test2`: instantiate bytes32 data, and implement code that calls `test.sol` and encodes its function `sum()` to bytes32 data. Pass `data` to `caller.sol` by writing something like: `caller.call{value: <ethamount>, <gasAmount>}(data)` --> what happens?
> 6. Test case 3: see what happens when you do test case 2 but with a function that has parameters. Back in `test.sol`, write a function `sumNum(uint256 x, uint256 y) public returns (uint256 sum)` that sums up both x and y. Do the same thing as test case 2 but with `sumNum` --> how does it differ from the result you get at the end of test case 2?
> 7. Test case 4: see what happens if you write implementation code in `executor.sol` within `calls()` where you implement `onlyOwner` from Openzeppelin. This would be pretty important I think. **This test will show whether or not there needs to be implementation code within an ext. contract for it to _receive and execute_ calldata carrying function signatures in it** If onlyOwner revert occurs when you run the tests, then I guess that means you could access it normally with an external contract, but if you implement onlyOwner then nope! Which is good. This is the hopeful result.
> 8. Finale: Can you get the bytes32 data for any public or external function call in any external contract that exists on a: A.) testnet or B.) your local hardhat network node? You would have to publish your contract to etherscan, get the bytes32 calldata for the respective function, pass it into your `executor.sol` contract, and voila! Either it works or doesn't :)
