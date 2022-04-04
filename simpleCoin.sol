pragma solidity >=0.7.0  <0.9.0;

contract Coin {
    address public minter;               //address type var
    mapping (address => uint) public balances;

    event Sent(address from, address to,  uint amount);    // booking



    constructor (){
        minter = msg.sender;     //sent through contract
    }

    function mint(address receiver, uint amount) public {
        require(msg.sender == minter);
        require(amount < 1e60);                /// condition 

        balances[receiver] += amount;  
    }

    function send(address receiver, uint amount) public {
        require(amount <= balances[msg.sender], "Insufficient balance.");
        balances[msg.sender] -= amount;
        balances[receiver] += amount; 
        emit Sent(msg.sender, receiver, amount); 
    }


}
