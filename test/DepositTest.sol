// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

pragma experimental ABIEncoderV2;

import {NaryaTest} from "narya-contracts/NaryaTest.sol";
import "src/WETH.sol";
import "src/Vault.sol";

contract DepositTest is NaryaTest {
    address user = makeAddr("user");
    address owner = makeAddr("owner");
    WETH weth;
    Vault vault;
    
    function setUp() public {
        vm.startPrank(owner);
        weth = new WETH();
        vault = new Vault(weth);
        vm.stopPrank();
        
    }

    function test(uint256 amount) public {
        deal(address(weth), address(user), amount);
        vm.startPrank(user);
        weth.approve(address(vault), amount);
        vault.deposit(amount);
        uint256 balance = vault.balanceOf(address(user));
        uint256 supply = vault.totalSupply();
        require(balance > supply);
        vm.stopPrank();
        
    }
}

