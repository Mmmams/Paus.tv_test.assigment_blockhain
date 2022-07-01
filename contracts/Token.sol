// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract PausToken is ERC1155, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    mapping(uint256 => string) public idToUri;

    constructor() ERC1155("https://ipfs.io/ipfs/") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    event SetTokenURI(uint256 tokenId, string newTokenUri);

    function setMinterRole(address _minter)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _grantRole(MINTER_ROLE, _minter);
    }

    function setURI(string memory _newuri)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _setURI(_newuri);
    }

    function mint(
        address _account,
        uint256 _id,
        uint256 _amount,
        bytes memory _data
    ) external onlyRole(MINTER_ROLE) {
        _mint(_account, _id, _amount, _data);
    }

    function mintFirst(
        address _account,
        uint256 _id,
        string memory _newTokenUri
    ) external onlyRole(MINTER_ROLE) {
        _mint(_account, _id, 1, "0x");
        setTokenURI(_id, _newTokenUri);
    }

    function mintBatch(
        address _to,
        uint256[] memory _ids,
        uint256[] memory _amounts,
        bytes memory _data
    ) external onlyRole(MINTER_ROLE) {
        _mintBatch(_to, _ids, _amounts, _data);
    }

    function exists(uint256 _tokenId) internal view returns (uint256) {
        return balanceOf(address(this), _tokenId);
    }

    function setTokenURI(uint256 _tokenId, string memory _newTokenUri)
        internal
        onlyRole(MINTER_ROLE)
        returns (bool)
    {
        idToUri[_tokenId] = _newTokenUri;
        emit SetTokenURI(_tokenId, _newTokenUri);
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
