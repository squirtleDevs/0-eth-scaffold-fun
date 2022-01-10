> The purpose of this document is to outline general "gotcha's" that apply to being a web3 dev.

### Ethereum Development

> Networks: There are several test networks one can use. Faucets that seem to be trustworthy are outlined at the bottom of this page: https://ethereum.org/en/developers/docs/networks/
>
> - Additional Faucets that work: https://faucets.chain.link/rinkeby

### Solidity Reading Notes

> This covers my notes on solidity from the main docs:

- Specifying versioning with logical signs: `pragma solidity >=0.4.16 <0.9.0` for example showcases specification of Solidity version 0.4.16 or a newer version of the langauge up to, but not including version 0.9.0.
- Calling functions can take multiple forms. I was familiar with the first one below for a function called `name` for example:
  - `name(first, last);`
  - `name({first: Steve, last: P.});`

`address` type: 160-bit value doesn't allow arithemtic ops. Stores addresses of contracts or a hash of the public half of a keypair for external accounts. -`public` allows access to current value of state variable from outside of contract. Without it, other contracts can't access the variable. Gets you a getter automatically. Compiler takes care of this!

- `mappings` are hash tables, virtually initialized with every possible key from the start and mapped to a value whose byte-representation is all zeros.
- `events` are listened to by Ethereum clients (web apps) emitted on the blockchain without much cost. Args are received from the emitted event which makes tracking txs possible.
- The msg variable (together with tx and block) is a special global variable that contains properties which allow access to the blockchain. msg.sender is always the address where the current (external) function call came from.
- Errors allow you to provide more information to the caller about why a condition or operation failed. Errors are used together with the revert statement. _The revert statement unconditionally aborts and reverts all changes similar to the require function, but it also allows you to provide the name of an error and additional data which will be supplied to the caller (and eventually to the front-end application or block explorer) so that a failure can more easily be debugged or reacted upon._

- If you use this contract to send coins to an address, you will not see anything when you look at that address on a blockchain explorer, because the record that you sent coins and the changed balances are only stored in the data storage of this particular coin contract. By using events, you can create a “blockchain explorer” that tracks transactions and balances of your new coin, but you have to inspect the coin contract address and not the addresses of the coin owners.
- What happens with double-spend attack? The abstract answer to this is that you do not have to care. A globally accepted order of the transactions will be selected for you, solving the conflict. The transactions will be bundled into what is called a “block” and then they will be executed and distributed among all participating nodes. If two transactions contradict each other, the one that ends up being second will be rejected and not become part of the block.

- If you want to schedule future calls of your contract, you can use a smart contract automation tool or an oracle service.
-

### EVM:

The Ethereum Virtual Machine or EVM is the runtime environment for smart contracts in Ethereum. It is not only sandboxed but actually completely isolated, which means that code running inside the EVM has no access to network, filesystem or other processes. Smart contracts even have limited access to other smart contracts.

- There are two kinds of accounts in Ethereum which share the same address space: External accounts that are controlled by public-private key pairs (i.e. humans) and contract accounts which are controlled by the code stored together with the account.
- The address of an external account is determined from the public key while the address of a contract is determined at the time the contract is created (it is derived from the creator address and the number of transactions sent from that address, the so-called “nonce”).
- _Regardless of whether or not the account stores code, the two types are treated equally by the EVM._
- Every account has a persistent key-value store mapping 256-bit words to 256-bit words called storage.

- Furthermore, every account has a balance in Ether (in “Wei” to be exact, 1 ether is 10\*\*18 wei) which can be modified by sending transactions that include Ether.

### Transactions:

- A payload is the binary data that is sent with a message from one account to another account.
- If the target account contains code, that code is executed and the payload is provided as input data.

- If the target account is not set (the transaction does not have a recipient or the recipient is set to null), the transaction creates a new contract. As already mentioned, the address of that contract is not the zero address but an address derived from the sender and its number of transactions sent (the “nonce”). The payload of such a contract creation transaction is taken to be EVM bytecode and executed. The output data of this execution is permanently stored as the code of the contract. This means that in order to create a contract, you do not send the actual code of the contract, but in fact code that returns that code when executed.
