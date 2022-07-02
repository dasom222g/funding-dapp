// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "DataType.sol";

contract Store is DataType {
    // mapping (uint256 => uint256) public targetAmounts; // tokeId, targetAmount
    // mapping (uint256 => uint256) public totalAmounts; // tokeId, totalAmount
    mapping (address => uint256) public donations; // 기부자 address, tokeId
    // mapping (uint256 => uint256) public tokenPrices; // tokeId, price
    // mapping (uint256 => uint256) public finishTime; // tokeId, finishTime

    TokenTypes[] public tokenDatas;
    uint256 public totalSupply;

    constructor() {}

    function getTokenDatas() external view returns(TokenTypes[] memory) {
        return tokenDatas;
    }

    function getTokenData(uint256 _tokenId) public view returns (TokenTypes memory) {
        TokenTypes memory tokenData;
        for (uint256 i = 0; i < tokenDatas.length; i++) {
            if (tokenDatas[i].tokenId == _tokenId) {
                tokenData = tokenDatas[i];
                break;
            }
        }
        return tokenData;
    }

    function setTokenDatas(TokenTypes memory _token) external {
        tokenDatas.push(_token);
    }

    function getTotalSupply() external view returns(uint256) {
        return totalSupply;
    }

    function addTotalSupply() external {
        totalSupply++;
    }
    function getAmount(address _owner) external view returns(uint256) {
        return donations[_owner];
    }

    function setDonation(address _owner, uint256 _amount) external {
        donations[_owner] += _amount;
    }
}