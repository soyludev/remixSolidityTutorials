pragma solidity >=0.7.0 <0.9.0;

// time stamp of the block




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
        uint createdTime;

    }

    function addPlayer(string memory firstName, string memory lastName) public {   //memory = how it saved
        players[msg.sender] = Player(msg.sender, Level.Novice,firstName, lastName, block.timestamp);
        //players.push(Player(firstName, lastName));
        playerCount+=1;
    }

    function getPlayerLevel(address playerAddress) public view returns(Level){
        Player storage player = players[playerAddress];
        return player.playerLevel;

    }

    function changePlayerLevel(address playerAddress) public {
        Player storage player = players[playerAddress];
        if (block.timestamp >= player.createdTime + 20) {
            player.playerLevel = Level.Intermediate; 
        }
    }
}

