// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract KipuBank {
    uint256 public immutable withdrawalLimit;
    uint256 public constant bankCap = 5 ether;
    uint256 public depositCount;

    mapping(address => uint256) public withdrawalCount;
    mapping(address => uint256) public accounts;

    constructor() {
        withdrawalLimit = 5 ether;
    }

    event EthReceived(address indexed from, uint256 amount);
    event EthWithdrawn(address indexed to, uint256 amount);

    error WithdrawalLimitExceeded();
    error InsufficientBalance();
    error BankCapExceeded();

    modifier validateWithdrawalAmount(address user, uint256 amount) {
        uint256 userBalance = accounts[user];

        if (amount > withdrawalLimit) revert WithdrawalLimitExceeded();
        if (userBalance <= 0 || userBalance < amount)
            revert InsufficientBalance();
        _;
    }

    receive() external payable {
        address sender = msg.sender;
        uint256 amount = msg.value;

        if (amount > bankCap) revert BankCapExceeded();

        depositCount++;
        accounts[sender] += amount;
        emit EthReceived(sender, amount);
    }

    function withdraw(address user, uint256 amount)
        external
        validateWithdrawalAmount(user, amount)
    {
        _processWithdrawal(msg.sender, amount);
    }

    function _processWithdrawal(address user, uint256 amount) private {
        accounts[user] -= amount;

        (bool success, ) = payable(user).call{value: amount}("");
        require(success, "ETH transfer failed");

        withdrawalCount[user]++;
        emit EthWithdrawn(user, amount);
    }
}
