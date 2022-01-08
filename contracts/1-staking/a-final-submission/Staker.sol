// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

/**
 * @title Staker
 * @author Steve P.
 * @notice "Scaffold-ETH Challenge 1" as per https://github.com/scaffold-eth/scaffold-eth-challenges/tree/challenge-1-decentralized-staking#-scaffold-eth---buidlguidl, and outlined here: https://medium.com/@austin_48503/%EF%B8%8Fethereum-dev-speed-run-bd72bcba6a4c
 * NOTE: contract v1 currently is on Rinkeby testnet: https://rinkeby.etherscan.io/address/0xcE1186D11f6363094Dd3C07717c6E057fFAa9c1c
 * NOTE: Deployer contract on rinkeby (showing txs for the two contracts here on testnet rinkeby etherscan): 0xc1D97D64B7e60aB22118f03F1cEaBcD9f10B8092
 * NOTE: Contract Staker is only a one-time contract. Once staking deadline is passed, there is no way to set deadline again to start a new staking time-frame. One could do this next phase of the contract through multiple ways, but is considered out of scope for this challenge (self interpretted). This also means that either the contract becomes open for withdrawing of funds, or it deposits total funds to the external contract once threshold is surpassed. Funds are not able to be withdrawn from ExampleExternalContract as that is not within the scope of this challenge as well.
 */
contract Staker {
    mapping(address => uint256) public balances;
    uint256 public constant threshold = 1 ether;
    uint256 cycleStart;
    uint256 deadline;
    bool openForWithdraw;
    bool executeCalled;

    ExampleExternalContract public exampleExternalContract;

    /* ========== EVENTS ========== */

    /**
     * @notice Emitted when an amount is staked
     */
    event Stake(address, uint256);

    event Received(address, uint256);

    /* ========== VIEWS ========== */

    /**
     * @notice Returns total wei staked in Staker.sol
     */
    function totalStaked() public view returns (uint256 contractStaked) {
        return address(this).balance;
    }

    /**
     * @notice returns individual user's total staked amount in staker.sol
     */
    function userStake() public view returns (uint256 userBalance) {
        return balances[msg.sender];
    }

    /**
     * @notice view function that returns the time left before the deadline for the frontend
     */
    function timeLeft() public view returns (uint256) {
        if (block.timestamp < deadline) {
            return (deadline - block.timestamp);
        } else {
            return 0;
        }
    }

    /* ========== MODIFIERS ========== */

    modifier notCompleted() {
        require(
            !exampleExternalContract.completed(),
            "Revert: ExampleExternalContract already complete, so funds are in ExampleExternalContract now and withdraw() can't be called in staker.sol."
        );
        _;
    }

    /* ========== CONSTRUCTOR ========== */

    constructor(address exampleExternalContractAddress) {
        exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
        setDeadline();
    }

    /* ========== MUTATIVE FUNCTIONS ========== */

    /**
     * @notice collect funds and track individual 'balances' with a mapping
     */
    function stake() public payable {
        require(timeLeft() != 0, "Revert: Passed staking phase, now can only call execute().");
        balances[msg.sender] += msg.value;
        emit Stake(msg.sender, msg.value);
    }

    /**
     * @notice allows users to withdraw from contract or transfers to external contract. Only called after deadline is passed, only once
     */
    function execute() public notCompleted {
        require(
            (timeLeft() == 0 && executeCalled == false),
            "Revert: deadline not passed yet, or execute() already called once."
        );

        uint256 currentStake = totalStaked();

        //check if staker.sol threshold passed, open up withdraw() function otherwise
        if (currentStake >= threshold) {
            exampleExternalContract.complete{ value: address(this).balance }();
            executeCalled = true;
        } else {
            openForWithdraw = true;
            executeCalled = true;
        }
    }

    /**
     * @notice withdraw user balance from staker.sol if threshold was not met before deadline
     */
    function withdraw() public notCompleted {
        require(
            openForWithdraw == true,
            "We aren't passed the staking deadline anon, or withdraw() closed since all ether has been withdrawn from staker.sol!"
        );

        require(balances[msg.sender] > 0, "You don't have any Ether staked anon!");
        uint256 withdrawAmount;
        withdrawAmount = balances[msg.sender];
        balances[msg.sender] = 0;
        address payable user = payable(msg.sender);
        user.transfer(withdrawAmount);

        if (totalStaked() == 0) {
            openForWithdraw = false;
        }
    }

    /**
     * @notice special function called when contract sent ether
     */
    receive() external payable {
        stake();
        emit Received(msg.sender, msg.value);
    }

    /**
     * @notice sets deadline upon contract creation
     */
    function setDeadline() internal {
        deadline = block.timestamp + 1 minutes;
    }
}
