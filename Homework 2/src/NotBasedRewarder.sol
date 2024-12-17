// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

// testing withdraw failures due to insufficient balance and paused token
import "forge-std/Test.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "./src/NotBasedRewarder.sol";

contract TestNotBasedRewarder is Test {
    ERC20Pausable depositToken;
    ERC20 rewardToken;
    NotBasedRewarder rewarder;

    address alice = address(0x1);

    function setUp() public {
        depositToken = new ERC20Pausable("DepositToken", "DT");
        rewardToken = new ERC20("RewardToken", "RT");

        rewarder = new NotBasedRewarder(IERC20(address(rewardToken)), IERC20(address(depositToken)));
        deal(address(depositToken), alice, 1000 ether); // give alice tokens
        deal(address(rewardToken), address(rewarder), 1000 ether);
    }

    function testWithdrawFailInsufficientBalance() public {
        vm.prank(alice);
        depositToken.approve(address(rewarder), 100 ether);
        rewarder.deposit(100 ether);

        vm.expectRevert(bytes("insufficient balance"));
        rewarder.withdraw(200 ether); // alice only has 100 deposited
    }

    function testWithdrawFailPausedToken() public {
        vm.prank(alice);
        depositToken.approve(address(rewarder), 100 ether);
        rewarder.deposit(100 ether);

        vm.prank(address(this)); // simulate owner action
        depositToken.pause(); // pause transfers

        vm.prank(alice);
        vm.expectRevert();
        rewarder.withdraw(100 ether); // transfer fails because token is paused
    }
}
