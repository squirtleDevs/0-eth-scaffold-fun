// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
 * @title ISimpleMultiSig
 * @author Steve P. @steve0xp
 * @notice This contract creates a single multi-sig wallet, ref: "Scaffold-ETH Challenge 2" as per https://github.com/scaffold-eth/scaffold-eth-challenges/tree/challenge-3-multi-sig.
 * @notice the multisig challenge hasn't been formalized yet so the link above doesn't outline the full scope of the challenge. Please refer to the README.md in this repo to see further details of the challenge.
 * @dev TODO: Users can tie into this contract and create more multisig by tying into the interface ISimpleMutiSig.sol, or through calling a separate function that calls on the constructor()...
 * NOTE: See README.md quick-break-down for my architecture of this contract
 */
interface ISimpleMultiSig {
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
     * NOTE:
     */
    function addSigner(address newSigner, uint256 newSignaturesRequired) external onlySelf;

    /**
     * @notice removes a new signer to the multi-sig wallet
     */
    function removeSigner(address oldSigner, uint256 newSignaturesRequired) external onlySelf;

    /**
     * @notice transfers a specific amount of funds to an account
     */
    function transferFunds(address payable to, uint256 value) external onlySelf;

    /**
     * @notice overwrites signature amount required
     */
    function updateSignaturesRequired(uint256 newSignaturesRequired) public onlySelf;

    /**
     * @notice returns transaction hash used to verify external address belongs to a signer within executeTransaction(). Can also be used to return transaction hash to be stored in backend (off-chain) to be voted on by signers
     */
    function getTransactionHash(
        uint256 _nonce,
        address to,
        uint256 value,
        bytes memory data
    ) external view returns (bytes32);

    /**
     * @notice executes tx after assessing that required signature minimum amount is met
     */
    function executeTransaction(
        address payable to,
        uint256 value,
        bytes memory data,
        bytes[] memory signatures
    );

    /**
     * @notice uses ECDSA recover method to obtain public address associated to a signed tx hash
     */
    function recover(bytes32 _hash, bytes memory _signature) external pure returns (address);

    receive() external payable;
}
