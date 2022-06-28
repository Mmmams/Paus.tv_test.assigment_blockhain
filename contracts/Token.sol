// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract PausToken is ERC1155, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    mapping(uint256 => string) private idToUri;

    constructor() ERC1155("https://ipfs.io/ipfs/") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    event SetTokenURI(uint256 tokenId, string newTokenUri);

    function setMinterRole(address minter)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _grantRole(MINTER_ROLE, minter);
    }

    function setURI(string memory newuri)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _setURI(newuri);
    }

    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) external onlyRole(MINTER_ROLE) {
        _mint(account, id, amount, data);
    }

    function mintFirst(address account, uint256 id)
        external
        onlyRole(MINTER_ROLE)
    {
        _mint(account, id, 1, "0x");
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) external onlyRole(MINTER_ROLE) {
        _mintBatch(to, ids, amounts, data);
    }

    function exists(uint256 tokenId) internal view returns (uint256) {
        return balanceOf(address(this), tokenId);
    }

    function setTokenURI(uint256 tokenId, string memory newTokenUri)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
        returns (bool)
    {
        idToUri[tokenId] = newTokenUri;
        emit SetTokenURI(tokenId, newTokenUri);
        return true;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC1155, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
