// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "DataType.sol";
import "Store.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MintToken is ERC1155Burnable, Ownable, DataType {
    string public name;
    string public symbol;

    Store public storeAddress;

    // 프로퍼티: targetAmount, totalAmount, price, donationAddress/amountList, finishTime

    string public baseURI;

    constructor(string memory _name, string memory _symbol, address _storeAddress) ERC1155("") {
        name = _name;
        symbol = _symbol;
        storeAddress = Store(_storeAddress);
    }

    // 1. 이미지를 ipfs에 올린다.
    // 2. 오픈씨를 위한 tokenURI 함수 추가

    function setURI(string memory newBaseURI) public onlyOwner {
        // https://gateway.pinata.cloud/ipfs/QmaPMUhMkKpKAtrTu6BPcjqq6jP31pQnEyjy2D6QkLnzbe
        baseURI = newBaseURI;
    }

    function tokenURI(uint256 _tokenId) public view returns (string memory) {
        string memory stringTokenId = Strings.toString(_tokenId);
        // baseURI 세팅 안됐을 경우 빈 스트링 리턴
        return bytes(baseURI).length > 0
            ? string(abi.encodePacked(baseURI, "/", stringTokenId, ".json"))
            : '';
    }

    function mintFundingToken(uint256 _targetAmount, uint256 _price) public onlyOwner {
        storeAddress.addTotalSupply();
        uint256 totalSupply = storeAddress.getTotalSupply();
        TokenTypes memory token = TokenTypes(
            totalSupply,
            _targetAmount,
            0,
            _price,
            block.timestamp + 2 weeks
        );
        storeAddress.setTokenDatas(token);
        _mint(owner(), totalSupply, _price, "");
    }

    function getTotalTokenCount() public view returns (uint256) {
        return storeAddress.getTotalSupply();
    }

    function getTokenDatas() public view returns (TokenTypes[] memory) {
        return storeAddress.getTokenDatas();
    }

    function getTokenData(uint256 _tokenId) public view returns (TokenTypes memory) {
        TokenTypes memory tokenData;
        TokenTypes[] memory tokenDatas = storeAddress.getTokenDatas();
        for (uint256 i = 0; i < tokenDatas.length; i++) {
            if (tokenDatas[i].tokenId == _tokenId) {
                tokenData = tokenDatas[i];
                break;
            }
        }
        return tokenData;
    }

}
