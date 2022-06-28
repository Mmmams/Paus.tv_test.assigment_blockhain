// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Token.sol";
import "./Interfaces/TokenInterface.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Marketplace {
    IToken internal token;
    address payable public feeAccount; // account that receives fees
    uint256 public feePercent; // fee percentage on sales
    mapping(uint256 => uint256) idToPrice;

    using Counters for Counters.Counter;

    Counters.Counter idCounter;

    constructor(IToken token, uint256 _feePercent) {
        token = IToken(token);
        feeAccount = payable(msg.sender);
        feePercent = _feePercent;
    }

    event Bought(
        uint256 nftId,
        address indexed nft,
        uint256 price,
        address indexed seller,
        address indexed buyer
    );

    function initialMint(string memory _newTokenUri, uint256 _price) external {
        idCounter.increment();
        token.mintFirst(msg.sender, idCounter.current(), _newTokenUri);
        idToPrice[idCounter.current()] = _price;
        emit Bought(
            idCounter.current(),
            address(token),
            _price,
            address(this),
            msg.sender
        );
    }

    function buy(
        uint256 _id,
        uint256 _amount,
        string memory _uri,
        bytes memory _data
    ) external payable {
        require(
            msg.value >= idToPrice[_id],
            "You need more currency for make a transaction"
        );

        token.mint(msg.sender, _id, _amount, _data);

        emit Bought(
            _id,
            address(token),
            idToPrice[_id],
            address(this),
            msg.sender
        );
    }
}
