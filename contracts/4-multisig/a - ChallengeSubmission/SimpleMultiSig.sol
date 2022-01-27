// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
 * @title MultiSigWallet
 * @author Steve P. @steve0xp
 * @notice This contract creates a single multi-sig wallet. TODO: Users can tie into this contract and create more multisig by tying into the interface ISimpleMutiSig.sol, or through calling a separate function that calls on the constructor()...
 */
contract SimpleMultiSig {
    
    /* ========== GLOBAL VARIABLES ========== */
    using ECDSA for bytes32;

    mapping(address => bool) public isOwner;
    uint256 public signaturesRequired;
    uint256 public nonce; //of respective person who is submitting a tx hash
    uint256 public chainId;

    /* ========== EVENTS ========== */

    /**
     * @notice Emitted when a new signer is added and new signature requirement amount is established
     */
    event SignerAdded(address newSigner, uint256 newSignaturesRequired);

    /**
     * @notice Emitted when a new signer is removed and new signature requirement amount is established
     */
    event SignerRemoved(address newSigner, uint256 newSignaturesRequired);

    /**
     * @notice Emitted when new amount of signatures are established from updateSignaturesRequired()
     */
    event UpdateSigsRequired(uint256 newSignaturesRequired);
    /**

     * @notice Emitted when ether is sent to this contract
     */
    event Deposit(address indexed sender, uint256 amount, uint256 balance);

    /**
     * @notice Emitted when a transaction is executed by this contract based on a successful vote
     */
    event ExecuteTransaction(
        address indexed owner,
        address payable to,
        uint256 value,
        bytes data,
        uint256 nonce,
        bytes32 hash,
        bytes result
    );

    /* ========== CONSTRUCTOR ========== */

    /**
     * @notice leverages for-loop --> mapping pattern for gas-efficient data record-keeping of: owners, and n/m signatures required for multisig.
     */
    constructor(
        address[] memory _owners,
        uint256 _signaturesRequired
    ) public {
        require(_signaturesRequired > 0, "constructor: must be non-zero signatures required");
        signaturesRequired = _signaturesRequired;
        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "constructor: owner cannot be a zero address");
            require(!isOwner[owner], "constructor: owner is already within the multisig");
            isOwner[owner] = true;
            emit Owner(owner, isOwner[owner]);
        }
    }

    /* ========== MODIFIERS ========== */

    /**
     * @notice used to ensure that only the multi-sig wallet itself can make sudo-level changes that require a proper vote (addSigner, removeSigner, updateSignaturesRequired). These all count as transactions so one would pass the hash of the tx into the pool to be voted on and then an owner would call executeTransaction() to carry it out.
     */
    modifier onlySelf() {
        require(msg.sender == address(this), "Not Self");
        _;
    }

    /* ========== MUTATIVE FUNCTIONS ========== */

    /**
     * @notice adds a new signer to the multi-sig wallet
     */
    function addSigner(address newSigner, uint256 newSignaturesRequired) public onlySelf {
        require(newSigner != address(0), "addSigner: revert due to newSigner is address(0)");
        require(!isOwner[newSigner], "addSigner: revert due to newSigner being already a signer!");
        require(newSignaturesRequired > 0, "addSigner: newSignaturesRequired must be > 0!");
        isOwner[newSigner] = true;
        signaturesRequired = newSignaturesRequired;
        emit SignerAdded(newSigner, signaturesRequired);
    }

    /**
     * @notice removes a new signer to the multi-sig wallet
     */
    function removeSigner(address oldSigner, uint256 newSignaturesRequired) public onlySelf {
        require(isOwner[oldSigner], "removeSigner: revert due to oldSigner not being a signer!");
        require(newSignaturesRequired > 0, "removeSigner: newSignaturesRequired must be > 0!");
        isOwner[oldSigner] = false;
        signaturesRequired = newSignaturesRequired;
        emit SignerRemoved(oldSigner, signaturesRequired);
    }

    /**
     * @notice overwrites signature amount required
     */
    function updateSignaturesRequired(uint256 newSignaturesRequired) public onlySelf {
        require(newSignaturesRequired > 0, "updateSignaturesRequired: newSignaturesRequired must be > 0!");
        signaturesRequired = newSignaturesRequired;
        emit UpdateSigsRequired(newSigner, signaturesRequired);

    }

    /**
     * @notice returns transaction hash used to verify public address belongs to a signer within executeTransaction(). Can also be used to return transaction hash to be stored in backend (off-chain) to be voted on by signers
     */
    function getTransactionHash(
        uint256 _nonce,
        address to,
        uint256 value,
        bytes memory data
    ) public view returns (bytes32) {
        require (_nonce > nonce, "getTransactionHash: revert due to SimpleMultiSig nonce > submitted nonce");
        bytes32 hash = keccak256(abi.encodePacked(addresss(this),chainId, _nonce, to, value, data)); bytes32(keccak256(data, _nonce, to, value);
        return hash;    
    }

    /**
     * @notice executes tx after assessing that required signature minimum amount is met
     */
    function executeTransaction(
        address payable to,
        uint256 value,
        bytes memory data,
        bytes[] memory signatures
    ) public returns (bytes memory) {
                require(isOwner[msg.sender], "executeTransaction: only owners can execute");
        bytes32 _hash = getTransactionHash(nonce, to, value, data);
        nonce++;
        uint256 validVotes;
        address duplicateGuard;

        for (uint256 i=0; i < signatures.length; i++) {
        address publicSigner = recover(_hash, signatures[i]);
        require(publicSigner > duplicateGuard, "executeTransaction: revert, duplicate or unordered signatures");
        duplicateGuard = recovered;
        if (isOwner[publicSigner]){
            validVotes++;
        } 
        }

        require(validVotes >= signaturesRequired, "executeTranscation: revert, not enough valid votes");

        (bool succes, bytes memory result) = to.call{value:value}(data);]
        require(success, "executeTransaction: revert, call() tx failed, possibly 'to' address is a user not a contract.");
        
        emit ExecuteTransaction(msg.sender, to, value, data, nonce-1, _hash, result);
        return result;
    }

    /**
     * @notice uses ECDSA recover method to obtain public address associated to a signed tx hash
     */
    function recover(bytes32 _hash, bytes memory _signature) public pure returns (address) {
        address publicSigner = _hash.toEthSignedMessageHash().recover(_signature);
        return publicSigner;
    }

    receive() external payable {
        emit Deposit(msg.sender, amount, address(this).balance);
    }
}
