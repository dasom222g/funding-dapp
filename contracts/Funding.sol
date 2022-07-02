// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";

import "MintToken.sol";
import "DataType.sol";
import "Store.sol";

contract Funding is Ownable, DataType {
    // 데드라인 시간에 if(모금액 >= 목표액) 모금액은 owner에게 전송
    // 데드라인 시간에 if(모금액 < 목표액) 모금액은 기부자들에게 환불
    // 프로퍼티: targetAmount, totalAmount, donationAddress/amountList, finishTime
    // 함수 recieve: payable하고 현재 시간이 finishTime 보다 작으면 실행되며donationList에 address => price가 저장됨,
    // 함수 recieve: totalAmount에 금액 추가됨
    // 함수 withdraw : 조건 만족할때 컨트랙트 생성자(owner)에게 송금
    // 함수 refund : 목표액 달성 못했을 경우 기부자들에게 환불

    MintToken public mintTokenAddress;
    Store public storeAddress;
    
    constructor(MintToken _mintTokenAddress, Store _storeAddress) {
        mintTokenAddress = _mintTokenAddress;
        storeAddress = _storeAddress;
    }
    
    function recieve(uint256 _tokenId) public payable {
        TokenTypes memory token = storeAddress.getTokenData(_tokenId);
        require(block.timestamp < token.finishTime, "Already Finished.");
        require(token.price == 0, "This token is not for sale.");
        require(msg.value >= token.price, "Caller sent lower than price.");
    }
}
