// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Example
 * @notice Example.sol is supposed to showcase how one can use `abi.encodeWithSignature()` to generate a hash that
 * can be passed into `<address>.call{value}(calldata)` as seen in `calls()`
 * @dev Store & retrieve value in a variable
 */
contract Example {
    uint256 number;

    /**
     * @dev Return value
     * @return value of 'number'
     */
    function retrieve() public view returns (uint256) {
        return number;
    }

    /**
     * @dev Store value in variable
     * @param num value to store
     */
    function store(uint256 num) public {
        number = num;
    }

    // generate signature (signed tx) in passable format to use with call()
    // @parameter fnDetails to be store(uint256) --> NOTE: although this is not working, the tx carries through, but the state var: num, does not change.
    function hash(string memory fnDetails, uint256 num) public view returns (bytes memory signedHash) {
        bytes memory hexString = abi.encodeWithSignature(fnDetails, num);
        return hexString;
    }

    // execute signed tx signature using global function .call()
    function calls(bytes memory signature) public payable {
        msg.sender.call{ value: msg.value }(signature);
    }
}
