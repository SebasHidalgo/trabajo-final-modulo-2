// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract KipuBank {
    //@notice límite por cada retiro de ETH
    uint256 public immutable withdrawalLimit;

    //@notice límite por cada deposito de ETH
    uint256 public constant bankCap = 5 ether;

    //@notice contador de la cantidad de depositos totales
    uint256 public depositCount;

    //@notice contador de retiros por usuario
    mapping(address => uint256) public withdrawalCount;

    //@notice contiene los balances de los usuarios mediante su address
    mapping(address => uint256) public accounts;

    constructor() {
        withdrawalLimit = 5 ether; // Se define el límite de ETH por cada retiro
    }

    //@notice evento que se emite cuando se recibe ETH
    event EthReceived(address indexed from, uint256 amount);

    //@notice evento que se emite cuando se retira ETH
    event EthWithdrawn(address indexed to, uint256 amount);

    //@notice error que se ejecuta cuando se excede el límite de retiro
    error WithdrawalLimitExceeded();

    //@notice error que se ejecuta cuando el balance es insuficiente
    error InsufficientBalance();

    //@notice error que se ejecuta cuando se excede el límite de deposito
    error BankCapExceeded();

    /*
    @notice modificador para validar cuando se haga un retiro
    */
    modifier validateWithdrawalAmount(address user, uint256 amount) {
        uint256 userBalance = accounts[user];

        if (amount > withdrawalLimit) revert WithdrawalLimitExceeded(); // validar que el monto digitado no sea mayor al límite de retiro
        if (userBalance <= 0 || userBalance < amount) // validar que el usuario tenga balance disponible y que el monto digitado sea menor al balance
            revert InsufficientBalance();
        _;
    }

    // @dev receive() - Se ejecuta para recibir ETH
    receive() external payable {
        address sender = msg.sender;
        uint256 amount = msg.value;

        if (amount > bankCap) revert BankCapExceeded(); // validar que el monto no exceda el límite de deposito

        depositCount++;
        accounts[sender] += amount;
        emit EthReceived(sender, amount);
    }

    /*
    @dev withdraw() - Función para realizar un retiro de ETH
    @param user dirección destino
    @param amount cantidad de ETH a retirar
    */ 
    function withdraw(address user, uint256 amount)
        external
        validateWithdrawalAmount(user, amount)
    {
        _processWithdrawal(msg.sender, amount);
    }

    /*
    @dev _processWithdrawal() - Función que contiene la lógica para retirar ETH
    @param user dirección destino
    @param amount cantidad de ETH a retirar
    */ 
    function _processWithdrawal(address user, uint256 amount) private {
        accounts[user] -= amount;

        (bool success, ) = payable(user).call{value: amount}("");
        require(success, "ETH transfer failed");

        withdrawalCount[user]++;
        emit EthWithdrawn(user, amount);
    }
}
