pragma solidity >=0.4.16 <0.9.0;

contract SimpleStorage{
    //local and global vars !!!

    uint storedData;      //not public
    //uint public storedData;   //public

    function set(uint x) public {    // you can call func outside
        storedData = x; 

    }

    function get() public view returns (uint){   // no modification
        return storedData;
    }
}
