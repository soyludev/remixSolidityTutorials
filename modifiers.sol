pragma solidity >=0.7.0  <0.9.0;

contract Coin {
    address public minter;               //address type var
    mapping (address => uint) public balances;

    event Sent(address from, address to,  uint amount);    // booking
 

    modifier onlyOwner {
        require(msg.sender == minter, "only minter can call this func");
        _;
    }

    modifier amountGreater(uint amount){
        require(amount <1e60)
    }

    constructor (){
        minter = msg.sender;     //sent through contract
    }

    function mint(address receiver, uint amount) public onlyOwner amountGreater(amount) {
        // require(msg.sender == minter);
        // require(amount < 1e60);                /// condition 

        balances[receiver] += amount;  
    }

    function send(address receiver, uint amount) public {
        require(amount <= balances[msg.sender], "Insufficient balance.");
        balances[msg.sender] -= amount;
        balances[receiver] += amount; 
        emit Sent(msg.sender, receiver, amount); 
    }


/* 

modifier: can be used to change the behaviour of functions in a declarative way. For example, 
          you can use a modifier to automatically check a condition prios to executuing the function

*/

}
