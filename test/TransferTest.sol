// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

pragma experimental ABIEncoderV2;

import {NaryaTest} from "narya-contracts/NaryaTest.sol";
import "src/WETH.sol";

contract TransferTest is NaryaTest {
    address user1 = makeAddr("user1");
    address user2 = makeAddr("user2");
    address owner = makeAddr("owner");
    WETH token;
    
    function setUp() public {
        vm.startPrank(owner);
        token = new WETH();
        vm.stopPrank();
        
    }

    function test(uint256 amount) public {
        deal(address(user1), amount);
        vm.startPrank(user1);
        token.deposit{value: amount}();
        token.transfer(address(user2), amount);
        uint256 totalSupply = token.totalSupply();
        require(totalSupply == amount);
        uint256 user1Balance = token.balanceOf(address(user1));
        require(user1Balance == 0);
        uint256 user2Balance = token.balanceOf(address(user2));
        require(user2Balance == amount);
        vm.stopPrank();
        
    }
}

