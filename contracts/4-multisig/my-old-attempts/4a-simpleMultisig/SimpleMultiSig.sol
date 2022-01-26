
// Let's create an multi-sig wallet. Here are the specifications.

// The wallet owners can

// submit a transaction
// approve and revoke approval of pending transcations
// anyone can execute a transcation after enough owners has approved it.

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

// // import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";
// import "./ExampleExternalContract.sol";

/**
 * @title SimpleMultiSig
 * @author Steve P.
 * @notice "Scaffold-ETH Challenge 4" as per https://twitter.com/austingriffith/status/1478760482710327296
 * NOTE: contract v1 currently is on Rinkeby testnet: <insert url>
 * NOTE: From Tweet: Next, build your own multisig using this as a reference: https://solidity-by-example.org/app/multi-sig-wallet/
 * NOTE: A multisig is simply an ext. contract that carries out function calls on behalf of a group of stakeholders (users). Txs are proposed, they are assessed, and carried out if they are approved. If they are not approved, the record of the proposal is still kept on-chain, but if ppl want to propose the same tx, they'll need to submit a new Tx with the same details.
 * 
 */
contract SimpleMultiSig {
    bytes32 passedCallData;
    struct ProposedTxs {
        bool executed;
        uint numConfirmations;
        uint256 value;
        address to;
        bytes data;
    }

    ProposedTxs[] public proposedTxs;
    uint256 txNum;
    address[] public owners;
    mapping (uint256 => mapping(address => bool)) public vote; 
    uint256 public numRequired;
    mapping (address => bool) public isOwner;

        mapping(uint => mapping(address => bool)) public isConfirmed;

    /* ========== EVENTS ========== */

    event Deposit(address indexed sender, uint amount, uint balance);


    // event ExtCall(); // emit when called with external contract function data

    // event ExtReceived(); // emit when receive a msg.call that has no data and thus calls receive()

    // event ExtFallback(); // emit when receive a msg.call that has data and thus activates fallback()

    /* ========== VIEWS ========== */

    /**
     * @notice Returns total wei
     */
    function totalEth() public view returns (uint256 total) {
        return address(this).balance;
    }

    /* ========== MODIFIERS ========== */

    modifier onlyOwner() {
    require(isOwner[msg.sender], "not owner");
    _;
    }

    modifier notExecuted(uint256 txNum) {
        require(!ProposedTxs[txNum].executed, "Already executed!");
        _;
    }

    modifier txExists(uint256 txNum) {
        require(txNum < proposedTxs.length, "tx does not exist");
        _;
    }
    
    modifier notConfirmed(uint256 txNum) {
        require(!isConfirmed[txNum][msg.sender],"tx already confirmed");
        _;
    }

    /* ========== CONSTRUCTOR ========== */

    constructor(address[] memory _owners,uint256 _numConfirmationsRequired) {
        require(_owners.length > 0, "Multisig requires at least one owner");
        require(_numConfirmationsRequired > 0 && _numConfirmationsRequired <= _owners.length, "Invalid amount of owners");
        

        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            
            require(owner != address(0), "cannot be address(0)");
            require(isOwner[owner] != true, "owner address already exists");
            isOwner(owner) = true;
            owners.push(owner); //used to view owners later
        }

        numRequired = _numConfirmationsRequired;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    /* ========== MUTATIVE FUNCTIONS ========== */

    // submit a transaction
    function submitTx(address _to, uint256 _value, bytes memory _calldata) public onlyOwner {
        uint txIndex = proposedTxs.length;

        proposedTxs.push(
            ProposedTxs({
                to: _to,
                value: _value,
                data: _data,
                executed: false,
                numConfirmations: 0
            })
         );

                 emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);

         }

    function confirmTx(uint txIndex) public onlyOwner notExecuted(txindex) txExists(txIndex) notConfirmed(txIndex) {
        ProposedTxs storage proposedTxs = proposedTxs[txIndex];
        proposedTxs[txIndex].numConfirmations += 1;
        isConfirmed[txIndex][msg.sender] = true;
    }

    function executeTx(uint txIndex) {
        ProposedTxs storage proposedTxs = proposedTxs[txIndex];
        require(proposedTxs.numConfirmations >= numRequired, "not enough votes to do the tx!");
        proposedTxs.executed = true; 

        (bool success, ) = proposedTxs.to.call{value: proposedTxs.value}(proposedTxs.data);
        require(success, "tx failed");
    }

    function revokeTx(uint txIndex) public onlyOwner notExecuted(txIndex) txExists(txIndex) notConfirmed(txIndex) {
        ProposedTxs storage proposedTxs = proposedTxs[txIndex];
        require(isConfirmed[txIndex][msg.sender], "tx not confirmed yet");
        proposedTxs[txIndex].numConfirmations -= 1;
        isConfirmed[txIndex][msg.sender] = false;
    }
}
