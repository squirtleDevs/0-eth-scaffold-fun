pragma solidity ^0.8.4;

/**
 * @author Steve P.
 * @notice ( A rework of the original Cryptogs (PizzaParlor) contract by Austin Griffith)
 *
 *   PizzaParlor -- a new venue for cryptogs games
  less transactions than original Cryptogs.sol assuming some
  centralization and a single commit reveal for randomness
*
 * Interface of the CryptogsGame contract where users can use erc1155 Cryptogs (v2) and play for keeps!
 */
interface ICryptogsGame {
    
    /* TODO: write these up at the end when we know what functions we're using. ========== EVENTS ========== */

/**
 * @notice emitted when transferStack() executed
 */
    event TransferStack(bytes32 indexed _commit,address indexed _sender,bytes32 indexed _receipt,uint _timestamp,uint256 _token1,uint256 _token2,uint256 _token3,uint256 _token4,uint256 _token5);

    /**
 * @notice emitted when transferStack() executed
 */
   event CoinFlip(bytes32 indexed _commit,bool _result,address _winner);

       /**
 * @notice emitted when transferStack() executed
 */
  event GenerateGame(bytes32 indexed _commit,address indexed _sender);

       /**
 * @notice emitted when transferStack() executed
 */
  event Flip(bytes32 indexed _commit,uint8 _round,address indexed _flipper,uint indexed _token);

       /**
 * @notice emitted when transferStack() executed
 */
   event DrainGame(bytes32 indexed _commit,address indexed _sender);

       /**
 * @notice emitted when transferStack() executed
 */
    event RevokeStack(bytes32 indexed _commit,address indexed _sender,uint _timestamp,uint256 _token1,uint256 _token2,uint256 _token3,uint256 _token4,uint256 _token5,bytes32 _receipt);


    /* ========== MUTATIVE FUNCTIONS ========== */

    
    /* ========== NON-CORE GAMEPLAY FUNCTIONS ========== */

  // to make less transactions on-chain, game creation will happen off-chain
  // at this point, two players have agreed upon the ten cryptogs that will
  // be in the game, five from each player
  // the server will generate a secret, reveal, and commit
  // this commit is used as the game id and both players share it
  // the server will pick one user at random to be the game master
  // this player will get the reveal and be in charge of generating the game
  // technically either player can generate the game with the reveal
  // (and either player can drain the stack with the secret)

    //tx1&2: players submit to a particular commit hash their stack of pogs (the two txs can happen on the same block, no one is waiting)
  //these go to the Cryptogs contract and it is transferStackAndCall'ed to here
  // event TransferStack emitted
  function onTransferStack(address _sender, uint _token1, uint _token2, uint _token3, uint _token4, uint _token5, bytes32 _commit) external;

  //tx3: either player, knowing the reveal, can generate the game
  //this tx calculates random, generates game events, and transfers
  // tokens back to winners
  //in order to make game costs fair, the frontend should randomly select
  // one of the two players and give them the reveal to generate the game
  // in a bit you could give it to the other player too .... then after the
  // timeout, they would get the secret to drain the stack
  function generateGame(bytes32 _commit,bytes32 _reveal,address _opponent,uint _token1, uint _token2, uint _token3, uint _token4, uint _token5,uint _token6, uint _token7, uint _token8, uint _token9, uint _token10) external;

//if the game times out without either player generating the game,
  // (the frontend should have selected one of the players randomly to generate the game)
  //the frontend should give the other player the secret to drain the game
  // secret -> reveal -> commit
  function drainGame(bytes32 _commit,bytes32 _secret,address _opponent,uint _token1, uint _token2, uint _token3, uint _token4, uint _token5,uint _token6, uint _token7, uint _token8, uint _token9, uint _token10) external;
    
  //if only one player ever ends up submitting a stack, they need to be able
  //to pull thier tokens back
  function revokeStack(bytes32 _commit,uint _token1, uint _token2, uint _token3, uint _token4, uint _token5) external;

    
}
