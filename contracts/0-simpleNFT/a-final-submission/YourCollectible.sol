pragma solidity >=0.6.0 <0.7.0;
// SPDX-License-Identifier: MIT

// import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//learn more: https://docs.openzeppelin.com/contracts/3.x/erc721
//reference material (see README.md here): https://github.com/scaffold-eth/scaffold-eth-challenges/tree/challenge-0-simple-nft

// GET LISTED ON OPENSEA: https://testnets.opensea.io/get-listed/step-two

contract YourCollectible is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint256 public constant nftPrice = 80000000000000; //0.08 ETH

    constructor() public ERC721("YourCollectible", "YCB") {
        _setBaseURI("https://ipfs.io/ipfs/");
    }

    function mintItem(
        address to,
        string memory tokenURI,
        uint256 dollas
    ) public payable returns (uint256) {
        //can only mint one nft at a time
        require(nftPrice <= dollas, "Ether value sent is not correct");
        _tokenIds.increment();

        uint256 id = _tokenIds.current();
        _mint(to, id);
        _setTokenURI(id, tokenURI);

        return id;
    }
}
