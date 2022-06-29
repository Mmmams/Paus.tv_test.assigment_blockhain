// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Token.sol";
import "./Interfaces/TokenInterface.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Marketplace is Ownable {
    IToken internal token;
    uint256 public feePercent;

    struct Nft {
        uint256 price;
        address payable creator;
    }

    mapping(uint256 => Nft) idToNft;

    using Counters for Counters.Counter;

    Counters.Counter idCounter;

    constructor(IToken _token, uint256 _feePercent) {
        token = IToken(_token);
        feePercent = _feePercent;
    }

    event Bought(
        uint256 nftId,
        address indexed nft,
        uint256 price,
        address indexed seller,
        address indexed buyer
    );

    event Created(
        uint256 nftId,
        address indexed nftAddress,
        uint256 price,
        address indexed creator
    );

    function initialMint(string memory _newTokenUri, uint256 _price) external {
        idCounter.increment();
        token.mintFirst(msg.sender, idCounter.current(), _newTokenUri);
        idToNft[idCounter.current()] = Nft(_price, payable(msg.sender));
        emit Created(idCounter.current(), address(token), _price, msg.sender);
    }

    function buy(
        uint256 _id,
        uint256 _amount,
        bytes memory _data
    ) external payable {
        require(
            msg.value >= idToNft[_id].price,
            "You need more currency for make a transaction"
        );
        address creator = idToNft[_id].creator;
        token.mint(msg.sender, _id, _amount, _data);
        (bool sent, ) = creator.call{
            value: (msg.value * (100 - feePercent)) / 100
        }("");
        require(sent, "Transaction failed");
        emit Bought(
            _id,
            address(token),
            idToNft[_id].price,
            address(this),
            msg.sender
        );
    }

    function withdraw(address recipient) external onlyOwner returns (bool) {
        require(address(this).balance >= 0, "Balance is zero");
        (bool sent, ) = recipient.call{value: address(this).balance}("");
        require(sent, "Transaction failed");
        return true;
    }
}
