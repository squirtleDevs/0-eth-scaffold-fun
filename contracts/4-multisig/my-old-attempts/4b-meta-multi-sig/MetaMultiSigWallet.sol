// SPDX-License-Identifier: MIT

//  Off-chain signature gathering multisig that streams funds - @austingriffith
//
// started from 🏗 scaffold-eth - meta-multi-sig-wallet example https://github.com/austintgriffith/scaffold-eth/tree/meta-multi-sig
//    (off-chain signature based multi-sig)
//  added a very simple streaming mechanism where `onlySelf` can open a withdraw-based stream
//

pragma solidity ^0.6.7;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/cryptography/ECDSA.sol";
import "./YourCollectible.sol";

contract MetaMultiSigWallet {
    using ECDSA for bytes32;

    event Deposit(address indexed sender, uint256 amount, uint256 balance);
    event ExecuteTransaction(
        address indexed owner,
        address payable to,
        uint256 value,
        bytes data,
        uint256 nonce,
        bytes32 hash,
        bytes result
    );
    event Owner(address indexed owner, bool added);
    event TransferFunds(address indexed reciever, uint256 value);
    event NewSudo(address newSudo, bool promoted); // SideQuest1: isSudo mapping!

    mapping(address => bool) public isOwner;
    uint256 public signaturesRequired;
    uint256 public nonce;
    uint256 public chainId;
    mapping(address => bool) public isSudo; // SideQuest1: isSudo mapping!
    YourCollectible yourCollectible; // SideQuest2: bringing in a different ext. contract that we will call some functions on!

    constructor(
        uint256 _chainId,
        address[] memory _owners,
        uint256 _signaturesRequired,
        address sudo
    ) public {
        require(_signaturesRequired > 0, "constructor: must be non-zero sigs required");
        signaturesRequired = _signaturesRequired;
        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "constructor: zero address");
            require(!isOwner[owner], "constructor: owner not unique");
            isOwner[owner] = true;
            emit Owner(owner, isOwner[owner]);
        }
        chainId = _chainId;
        isSudo[sudo] = true;
    }

    modifier onlySelf() {
        require(msg.sender == address(this), "Not Self");
        _;
    }

    // SideQuest1: pairs with customRoles() function
    modifier customRules() {
        require(isSudo[msg.sender], "customRules: only Sudo accounts can propose executable txs.");
        _;
    }

    /**
     * @notice sideQuest1: create custom signer roles for this wallet
     * NOTE: only allow default signers to sign existing txs, and also create a mega-admin role that can veto txs. Pairs with modifier customRules().
     * I think that the new multisig would have roles implemented by using recover() and ensuring that the megarole is the one that has been given sudo rights to create the tx in the first place. Execute() is the function that uses a looped array to carry out the votes for the respective tx. I'm not sure how the front end ties with it but that doesn't matter for now.
     * customRoles() will allow people to submit their address to become a sudo user. If there are other types of special roles that we want to create, I think we'd have to code them into the smart contract first upon deployment. So then you have a cycle of different roles that you can cycle through.
     */
    function customRoles(address[] memory newSudos) public customRules {
        for (uint256 i = 0; i < newSudos.length; i++) {
            address newSudo = newSudos[i];
            require(newSudo != address(0), "customRoles: zero address");
            require(isOwner[newSudo], "customRoles: address that is not a previous owner wrongly submitted");
            require(!isSudo[newSudo], "customRoles: address(es) given are already sudo");
            isSudo[newSudo] = true;
            emit NewSudo(newSudo, isSudo[newSudo]);
        }
    }

    function addSigner(address newSigner, uint256 newSignaturesRequired) public onlySelf {
        require(newSigner != address(0), "addSigner: zero address");
        require(!isOwner[newSigner], "addSigner: owner not unique");
        require(newSignaturesRequired > 0, "addSigner: must be non-zero sigs required");
        isOwner[newSigner] = true;
        signaturesRequired = newSignaturesRequired;
        emit Owner(newSigner, isOwner[newSigner]);
    }

    function removeSigner(address oldSigner, uint256 newSignaturesRequired) public onlySelf {
        require(isOwner[oldSigner], "removeSigner: not owner");
        require(newSignaturesRequired > 0, "removeSigner: must be non-zero sigs required");
        isOwner[oldSigner] = false;
        signaturesRequired = newSignaturesRequired;
        emit Owner(oldSigner, isOwner[oldSigner]);
    }

    function transferFunds(address payable to, uint256 value) public onlySelf {
        require(address(this).balance > value, "Not enough funds in Wallet");
        emit TransferFunds(to, value);
        to.transfer(value);
    }

    function updateSignaturesRequired(uint256 newSignaturesRequired) public onlySelf {
        require(newSignaturesRequired > 0, "updateSignaturesRequired: must be non-zero sigs required");
        signaturesRequired = newSignaturesRequired;
    }

    function getTransactionHash(
        uint256 _nonce,
        address to,
        uint256 value,
        bytes memory data
    ) public view returns (bytes32) {
        return keccak256(abi.encodePacked(address(this), chainId, _nonce, to, value, data));
    }

    /**
     * @notice SideQuest2: embed multisig into usage of ext. contract YourCollectible.sol
     * NOTE: txHash() creates a `bytes data` to be passed into executeTransaction(). The result of calling executeTransaction() with it should be that the multisig receives an NFT!
     * NOTE: lessons include: passing in ext. contract function calls without inheritance or importing via libraries.
     */
    function txHash(
        address _extContract,
        string memory _fnName,
        address _to,
        string memory _tokenURI,
        uint256 _dollas
    ) public view returns (bytes memory signedHash) {
        yourCollectible = YourCollectible(_extContract);

        bytes memory hexString = abi.encode(_fnName, _tokenURI, _dollas);
        return hexString;
    }

    function executeTransaction(
        address payable to,
        uint256 value,
        bytes memory data,
        bytes[] memory signatures
    ) public returns (bytes memory) {
        require(isOwner[msg.sender], "executeTransaction: only owners can execute");
        bytes32 _hash = getTransactionHash(nonce, to, value, data);
        nonce++;
        uint256 validSignatures;
        address duplicateGuard;
        uint256 sudoPresent;

        //SideQuest1!
        for (uint256 i = 0; i < signatures.length; i++) {
            address recovered = recover(_hash, signatures[i]);
            if (isSudo[recovered]) {
                sudoPresent++;
            }
        }
        require(sudoPresent > 0, "isSudo: tx is not proposed by a Sudo address"); // SideQuest1!

        for (uint256 i = 0; i < signatures.length; i++) {
            address recovered = recover(_hash, signatures[i]);
            require(recovered > duplicateGuard, "executeTransaction: duplicate or unordered signatures");
            duplicateGuard = recovered;
            if (isOwner[recovered]) {
                validSignatures++;
            }
        }

        require(validSignatures >= signaturesRequired, "executeTransaction: not enough valid signatures");

        (bool success, bytes memory result) = to.call{ value: value }(data);
        require(success, "executeTransaction: tx failed");

        emit ExecuteTransaction(msg.sender, to, value, data, nonce - 1, _hash, result);
        return result;
    }

    function recover(bytes32 _hash, bytes memory _signature) public pure returns (address) {
        return _hash.toEthSignedMessageHash().recover(_signature);
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    //
    //  new streaming stuff
    //

    event OpenStream(address indexed to, uint256 amount, uint256 frequency);
    event CloseStream(address indexed to);
    event Withdraw(address indexed to, uint256 amount, string reason);

    struct Stream {
        uint256 amount;
        uint256 frequency;
        uint256 last;
    }
    mapping(address => Stream) public streams;

    function streamWithdraw(uint256 amount, string memory reason) public {
        require(streams[msg.sender].amount > 0, "withdraw: no open stream");
        _streamWithdraw(msg.sender, amount, reason);
    }

    function _streamWithdraw(
        address payable to,
        uint256 amount,
        string memory reason
    ) private {
        uint256 totalAmountCanWithdraw = streamBalance(to);
        require(totalAmountCanWithdraw >= amount, "withdraw: not enough");
        streams[to].last =
            streams[to].last +
            (((block.timestamp - streams[to].last) * amount) / totalAmountCanWithdraw);
        emit Withdraw(to, amount, reason);
        to.transfer(amount);
    }

    function streamBalance(address to) public view returns (uint256) {
        return (streams[to].amount * (block.timestamp - streams[to].last)) / streams[to].frequency;
    }

    function openStream(
        address to,
        uint256 amount,
        uint256 frequency
    ) public onlySelf {
        require(streams[to].amount == 0, "openStream: stream already open");
        require(amount > 0, "openStream: no amount");
        require(frequency > 0, "openStream: no frequency");

        streams[to].amount = amount;
        streams[to].frequency = frequency;
        streams[to].last = block.timestamp;

        emit OpenStream(to, amount, frequency);
    }

    function closeStream(address to) public onlySelf {
        require(streams[to].amount > 0, "closeStream: stream already closed");
        _streamWithdraw(address(uint160(to)), streams[to].amount, "stream closed");
        delete streams[to];
        emit CloseStream(to);
    }
}
