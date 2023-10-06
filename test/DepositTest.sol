// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

pragma experimental ABIEncoderV2;

import {NaryaTest} from "narya-contracts/NaryaTest.sol";
import "src/WETH.sol";
import "src/Vault.sol";

contract DepositTest is NaryaTest {
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

    function test(uint256 amount) public {
        vm.startPrank(user);
        vault.deposit(amount);
        skip(1 days);
        uint256 shares = vault.balanceOf(address(user));
        require(shares > 0);
        vm.stopPrank();
        
    }
}
