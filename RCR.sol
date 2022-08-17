// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;

contract RCRtoken {
    // talk about events here needed
    /* transfer and approve requests and transactions for the user

    */
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed receiver, uint tokens);

    // Fields
    string public constant name = "RecipeRace Token";
    string public constant symbol = "RRT";
    uint public constant decimal = 18;

//CHECKING info from user
    // MAPPING { 0x0 : 5000 Token }
    // address: 100000 MOC
    mapping(address => uint) balances;
    // Map
    // {0x0: {0x1(some one else): 100 tokens} }
    mapping(address => mapping(address => uint)) allowedTransactions;

    // Supply
    uint _totalSupply;


    constructor(uint inputValue) {
        _totalSupply = inputValue;
        // msg.sender => your metamask 
        balances[msg.sender] = _totalSupply;
    }

    // 1st required function
    function totalSupply() public view returns(uint) {
        return _totalSupply;
    }

    // 2nd required fucntion
    function balanceOf(address owner) public view returns(uint) {
        return balances[owner];
    } 

    function transfer(address receiver, uint numOfTokens) public returns(bool) {
        // strictly say if we have enought tokens to send
        // Sending tokens from my address to yours
        require(numOfTokens <= balances[msg.sender], 'Insufficient Funds');
        // remove the number tokens from balances we are going to send
        balances[msg.sender] -= numOfTokens;
        // send the number of tokens to the other user
        balances[receiver] += numOfTokens;
        // Here is where our event frunction is emitted, we are calling
        // Helps us verify the transaction
        emit Transfer(msg.sender, receiver, numOfTokens);
        return true;
    }

// Approval of minting tokens
    function approve(address receiver, uint numOfTokens) public returns(bool) {
        // Populate allowed Transactions
        allowedTransactions[msg.sender][receiver] = numOfTokens;
        // Emit our approval
        emit Approval(msg.sender, receiver, numOfTokens);
        return true;
    }

    function allowance(address owner, address otherAccount) public view returns(uint) {
        return allowedTransactions[owner][otherAccount];
    }

    function transferFrom(address owner, address otherAccount, uint numOfTokens) public returns(bool) {
        // Set a a check using required
        require(numOfTokens <= balances[owner], 'Insufficient Funds');
        // We want to do another,
        // Allowed 
        require(numOfTokens <= allowedTransactions[owner][otherAccount], 'You are not allowed to send this account');
        balances[owner] -= numOfTokens;
        // Send money from account to account
        allowedTransactions[owner][msg.sender] -= numOfTokens;
        balances[otherAccount] += numOfTokens;
        emit Transfer(owner, otherAccount, numOfTokens);

        return true;
    }
}