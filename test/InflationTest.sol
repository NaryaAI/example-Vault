// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

pragma experimental ABIEncoderV2;

import {NaryaTest} from "narya-contracts/NaryaTest.sol";
import "src/WETH.sol";
import "src/Vault.sol";

contract InflationTest is NaryaTest {
    address owner = makeAddr("owner");
    address user = makeAddr("user");
    address attacker = makeAddr("attacker");
    WETH weth;
    Vault vault;
    
    function setUp() public {
        vm.startPrank(owner);
        weth = new WETH();
        vault = new Vault(weth);
        deal(address(weth), address(user), 10 ether);
        deal(address(weth), address(attacker), 10 ether);
        vm.stopPrank();

        vm.startPrank(user);
        weth.approve(address(vault), 10 ether);
        vm.stopPrank();

        vm.startPrank(attacker);
        weth.approve(address(vault), 10 ether);
        vm.stopPrank();
        
    }

    function test(uint256 depositAmount, uint256 inflationAmount) public {
        vm.startPrank(attacker);
        vault.deposit(depositAmount);
        weth.transfer(address(vault), inflationAmount);
        vm.stopPrank();

        vm.startPrank(user);
        vault.deposit(1 ether);
        uint256 userShares = vault.balanceOf(address(user));
        require(userShares > 0);
        vm.stopPrank();
        
    }
}
