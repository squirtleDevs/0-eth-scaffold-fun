// SPDX-License-Identifier: MIT

//  Off-chain signature gathering multisig that streams funds - @austingriffith
//
// started from 🏗 scaffold-eth - meta-multi-sig-wallet example https://github.com/austintgriffith/scaffold-eth/tree/meta-multi-sig
//    (off-chain signature based multi-sig)
//  added a very simple streaming mechanism where `onlySelf` can open a withdraw-based stream
//

pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
 * @title StreamingMetaMultiSig
 * @notice Empty contract that just outlines what features could be part of the challenge (up to you!)
 * @dev This contract creates a single multi-sig wallet.
 */
contract StreamingMetaMultiSig {
    
    /* ========== GLOBAL VARIABLES ========== */
    using ECDSA for bytes32;

    mapping(address => bool) public isOwner;
    uint public signaturesRequired;
    uint public nonce; //of respective person who is submitting a tx hash
    uint public chainId;

    //streaming variables
    struct Stream {
        uint256 amount;
        uint256 frequency;
        uint256 last;
    }
    mapping(address => Stream) public streams;
    
    /* ========== EVENTS ========== */

    /**
     * @notice Emitted when 
     */
    event Deposit(address indexed sender, uint amount, uint balance);

    /**
     * @notice Emitted when
     */
    event ExecuteTransaction( address indexed owner, address payable to, uint256 value, bytes data, uint256 nonce, bytes32 hash, bytes result);

    /**
     * @notice Emitted when
     */
    event TransferFunds(address indexed reciever, uint256 value);

    /**
     * @notice Emitted when
     */
         event OpenStream( address indexed to, uint256 amount, uint256 frequency );


         /**
     * @notice Emitted when
     */
         event CloseStream( address indexed to );


         /**
     * @notice Emitted when
     */
         event Withdraw( address indexed to, uint256 amount, string reason );



    /* ========== CONSTRUCTOR ========== */
    
    /**
     * @notice leverages for-loop --> mapping pattern for gas-efficient data record-keeping of: owners, and n/m signatures required for multisig.
     */
    constructor(uint256 _chainId, address[] memory _owners, uint _signaturesRequired) public {
        require(_signaturesRequired>0,"constructor: must be non-zero sigs required");
        signaturesRequired = _signaturesRequired;
        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner!=address(0), "constructor: zero address");
            require(!isOwner[owner], "constructor: owner not unique");
            isOwner[owner] = true;
            emit Owner(owner,isOwner[owner]);
        }
        chainId=_chainId;
    }

        /* ========== MODIFIERS ========== */

    /**
     * @notice used to ensure that only the multi-sig wallet itself can make sudo-level changes that require a proper vote (addSigner, removeSigner, transferFunds, updateSignaturesRequired). These all count as transactions so one would pass the hash of the tx into the pool to be voted on and then an owner would call executeTransaction() to carry it out.
     */
        modifier onlySelf() {
        require(msg.sender == address(this), "Not Self");
        _;
    }

    /* ========== MUTATIVE FUNCTIONS ========== */

    /**
     * @notice adds a new signer to the multi-sig wallet
     */
    function addSigner(address newSigner, uint256 newSignaturesRequired) public onlySelf {}

    /**
     * @notice removes a new signer to the multi-sig wallet
     */
    function removeSigner(address oldSigner, uint256 newSignaturesRequired) public onlySelf {}
   
    /**
     * @notice transfers a specific amount of funds to an account
     */
    function transferFunds(address payable to, uint256 value) public onlySelf {}

    /**
     * @notice overwrites signature amount required
     */
    function updateSignaturesRequired(uint256 newSignaturesRequired) public onlySelf {}
    
    /**
     * @notice returns transaction hash to be stored in backend (off-chain) to be voted on by signers
     * @param _nonce is for the contract, it increments in executeTransaction. Since we're using call(){}, I think that means that it counts as an ext. tx even if it is calling itself? See this for how contract nonces work: https://ethereum.stackexchange.com/questions/764/do-contracts-also-have-a-nonce
     * TODO: look up duplicateGuard --> oh I think this is so votes aren't double counted. Not sure how they could get out of order.
     */
    function getTransactionHash( uint256 _nonce, address to, uint256 value, bytes memory data ) public view returns (bytes32) {
    }

    /**
     * @notice executes tx after assessing that required signature minimum amount is met
     */
    function executeTransaction( address payable to, uint256 value, bytes memory data, bytes[] memory signatures) {}    


    /**
     * @notice uses ECDSA recover method to obtain public address associated to a signed tx hash
     */
    function recover(bytes32 _hash, bytes memory _signature) public pure returns (address) {
    }

    receive() payable external {
        }

    /**
     * @notice calls _streamWithdraw()
     */
    function streamWithdraw(uint256 amount, string memory reason) public {}

    /**
     * @notice transfers amount to payee from multisig
     */
    function _streamWithdraw(address payable to, uint256 amount, string memory reason) private {


    /**
     * @notice returns remaining balance of stream for respective user
     */ 
    function streamBalance(address to) public view returns (uint256){}
   


    /**
     * @notice opens individual streams of ether to a respective user
     */     
    function openStream(address to, uint256 amount, uint256 frequency) public onlySelf {}

    /**
     * @notice closes and deletes the open stream to a specific user
     */       
    function closeStream(address to) public onlySelf {}       

    
}