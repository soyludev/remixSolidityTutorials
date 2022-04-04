pragma solidity >=0.7.0 <0.9.0; 


contract myContract {
    uint public myUint = 1;  // a public integer greater than zero
    uint public constant myConstUint = 1;  // a public constant integer greater than zero   
    
    int public myInt = -1;  // a public integer 

    string public myString = "my string "; // a public string

    bool public myBool = true;   // a public boolen value

}

contract myGame {

    uint public playerCount = 0;
    //Player[] public players;
    mapping (address => Player) public players;
    enum Level {Novice, Intermediate, Advanced}       //it must be one of these three


    struct Player {  //records, similiar like object in OOP
        address playerAddress;
        Level playerLevel; 
        string firstName; 
        string lastName; 
    }

    function addPlayer(string memory firstName, string memory lastName) public {   //memory = how it saved
        players[msg.sender] = Player(msg.sender, Level.Novice,firstName, lastName);
        //players.push(Player(firstName, lastName));
        playerCount+=1;
    }

    function getPlayerLevel(address playerAddress) public view returns(Level){
        return players[playerAddress].playerLevel;

    }
}


/* ----

constant : keyword added to a variable that tells solidity it cannet be changed
struct : Struct type are used to represent a record. They allow you to create your own data type.
enum : enums restict a variable to have one of only a few predefined values. The values in this enumarated list are called enums.
array : Player[] public players; 

*/
