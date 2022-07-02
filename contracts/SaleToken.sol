// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";

import "MintToken.sol";

contract SaleMetaAidToken is Ownable {
    MintToken public mintToken;

    address public aidAddress;

    constructor(address _mintToken, address _aidAddress) {
        mintToken = MintToken(_mintToken);
        aidAddress = _aidAddress;
    }

    mapping(uint256 => uint256) public tokenPrices;
    mapping(uint256 => uint256) public remainTokens;

    uint256 public totalAidPrice;

    uint256 public saleTokenAmount;

    function setForSaleMetaAidToken(uint256 _tokenId, uint256 _price)
        public
        onlyOwner
    {
        require(_price > 0, "Price is zero is lower.");
        require(
            tokenPrices[_tokenId] == 0,
            "This MetaAidToken is already on sale."
        );
        require(
            mintToken.isApprovedForAll(owner(), address(this)),
            "Owner did not approve."
        );

        tokenPrices[_tokenId] = _price;
        remainTokens[_tokenId] = mintToken.balanceOf(msg.sender, _tokenId);
    }

    function purchaseMetaAidToken(uint256 _tokenId) public payable {
        uint256 price = tokenPrices[_tokenId];

        require(price > 0, "This MetaAidToken is not on sale.");
        require(price <= msg.value, "Caller sent lower than price.");
        require(owner() != msg.sender, "Caller is service address.");
        require(remainTokens[_tokenId] > 0, "This MetaAidToken is sold out.");

        payable(aidAddress).transfer(msg.value);

        mintToken.safeTransferFrom(owner(), msg.sender, _tokenId, 1, "");

        totalAidPrice += msg.value;

        saleTokenAmount += 1;

        remainTokens[_tokenId] -= 1;
    }

    function getMetaAidTokens(address _owner)
        public
        view
        returns (uint256[] memory, uint256[] memory)
    {
        uint256 totalSupply = mintToken.totalSupply();

        require(totalSupply > 0, "Not exist MetaAidToken.");

        uint256[] memory tokenIds = new uint256[](totalSupply);
        uint256[] memory tokenAmounts = new uint256[](totalSupply);

        for (uint256 i = 0; i < totalSupply; i++) {
            uint256 tokenId = i + 1;
            uint256 tokenAmount = mintToken.balanceOf(_owner, tokenId);

            tokenIds[i] = tokenId;
            tokenAmounts[i] = tokenAmount;
        }

        return (tokenIds, tokenAmounts);
    }

    function getMetaAidTokenData(uint256 _tokenId)
        public
        view
        returns (
            string memory,
            uint256,
            uint256
        )
    {
        string memory tokenUri = mintToken.uri(_tokenId);
        uint256 tokenPrice = tokenPrices[_tokenId];
        uint256 remainToken = remainTokens[_tokenId];

        return (tokenUri, tokenPrice, remainToken);
    }

    function setAidAddress(address _aidAddress) public onlyOwner {
        aidAddress = _aidAddress;
    }
}
