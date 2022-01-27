pragma solidity >=0.6.0 <0.7.0;

//import "hardhat/console.sol";

////// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/cryptography/ECDSA.sol
import "@openzeppelin/contracts/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * NOTE: This contract basically has the building blocks for the executor.sol challenge! You gotta know what you're doing though :) 
 *
 Recall the basics: 64 character private key uses hashing function to come up with a public address that lives on the EVM. Use private key to sign any kind of msg. The msg could be anything, ex.) "hello world", and generates a signature (hexstring) when privately signed! GOTCHA: you can put the signature (hexstring) into ECDSA.recover() with the message(bytes32 bc it is encoded following v, s, r), and get the public address of the person who privately signed it! Using this setup, you can essentially get a "manifest" of sorts in the blockchain of the respective tx!
 *
 * Also recall: a contract is deployed bytecode (compiled from your high-level language smart contract), in a message to the EVM, with no "to" and the "data" is the contract bytecode! From there you pass in a tx to the deployed contract, with calldata (hexstring) that contains the bytes32 message, and hexstring signature (both of which are hashed together to get another hexstring!)
 */
contract YourContract is Ownable {
    using ECDSA for bytes32; // SP: see https://docs.openzeppelin.com/contracts/2.x/utilities

    uint256 public nonce = 0;

    /**
     * @notice generates hash for tx hexstring
     * @param _nonce contract nonce
     * @param to account or ext contract ether will be sent to from this contract
     * @param value ether to be sent from contract
     */
    function getHash(
        uint256 _nonce,
        address to,
        uint256 value
    ) public view returns (bytes32) {
        return keccak256(abi.encodePacked(address(this), _nonce, to, value)); // SP: https://docs.soliditylang.org/en/v0.8.11/050-breaking-changes.html?highlight=keccak256#semantic-and-syntactic-changes
    }

    /**
     * @notice sends encoded tx
     * @param to account getting ether from contract
     * @param value ether sent from contract
     * @param signature return value from getHash() or some other encodePacked tx at a specific nonce. Think of it as the owner signing a cheque, and the signature is the owners proof of signature. You generate the signature when private-signing a message (which could contain calldata and calls upon a function(s)). metaSendValue() checks that the signer is authentically the owner. The contract function, in this case a simple transfer() I think, also has a nonce; aka the contract nonce. Ah, so this is always the contract nonce here. We get the hash through the contract nonce, the other attributes too of the function call. We check that the owner signed that nonce of the contract with those function call details using recover. If it's good, then we metaSendValue --> aka send the message containing instructions to carry out the tx! It is signed by the owner, but is called by a proxy contract to pay the gas.
     */
    function metaSendValue(
        address payable to,
        uint256 value,
        bytes memory signature
    ) public {
        bytes32 hash = getHash(nonce, to, value);
        address signer = recover(hash, signature); // SP: using ECDSA.recover one obtains the signature of the passed along hashed tx ("signature")!
        require(signer == owner(), "SIGNER MUST BE OWNER");
        nonce++;
        (
            bool success, /* bytes memory data */

        ) = to.call{ value: value }("");
        require(success, "TX FAILED");
    }

    /**
     * @notice shows how recover works, returning signer of a hashed function (hexstring)
     * @param hash hashed transaction details without a signature
     * @param signature privately signed tx hexstring
     * NOTE: I think that ECDSA already does recover if you use one of the functions implemented within it, but I could be wrong. Have to check!
     */
    function recover(bytes32 hash, bytes memory signature) public pure returns (address) {
        return hash.toEthSignedMessageHash().recover(signature); // https://docs.openzeppelin.com/contracts/2.x/utilities
    }

    receive() external payable {
        /* allow deposits */
    }
}
