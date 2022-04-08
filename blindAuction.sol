pragma solidity >=0.7.0 <0.9.0; 

// blind auction 


contract blindAuction{

    //vars
    struct Bid {
        bytes32 blindedBid; 
        uint deposit;

    }

    address payable public beneficiary; 
    uint public biddingEnd; 
    uint public revealEnd; 
    bool public ended;

    mapping(address => Bid[]) public bids; 

    address public highestBidder;
    uint public highestBid; 

    mapping(address => uint) pendingReturns; 



    // events 
    event AuctionEnded(address winner, uint highestBid);

    // modifiers
    modifier onlyBefore(uint _time) { require(block.timestamp < _time); _; }
    modifier onlyAfter(uint _time) { require(block.timestamp > _time); _;}

    // funcs
    constructor(
        uint _biddingTime,
        uint _revealTime, 
        address payable _beneficiary 
        ){

        beneficiary = _beneficiary; 
        biddingEnd = block.timestamp + _biddingTime; 
        revealEnd = biddingEnd + _revealTime; 
    }
    
    function generateBlindedBidBytes32(uint value, bool fake) public view returns(bytes32) {
        return keccak256(abi.encodePacked(value, fake));   //returns encrypted value
    }

    function bid(bytes32 _blindedBid) public payable onlyBefore(biddingEnd) {
        bids[msg.sender].push(Bid({
            blindedBid: _blindedBid, 
            deposit: msg.value
        }));


    }

    function reveal(
        uint[] memory _values, 
        bool[] memory _fake
    ) public 
      onlyAfter(biddingEnd)
      onlyBefore(revealEnd)  
    {
        uint length = bids[msg.sender].length;
        require (_values.length == length);
        require (_fake.length == length);

        //uint refund;

        for (uint i=0; i<length; i++){
            Bid storage bidToCheck = bids[msg.sender][i];
            (uint value, bool fake) = (_values[i], _fake[i]);
            if (bidToCheck.blindedBid != keccak256(abi.encodePacked(value,fake))){
                continue;
            }
//            refund += bidToCheck.deposit;
            if(!fake && bidToCheck.deposit >= value){
               if(!placeBid(msg.sender, value)){
                  payable(msg.sender).transfer(bidToCheck.deposit * (1 ether)); 
                   //refund -= value;

               }
            }
            bidToCheck.blindedBid = bytes32(0);
        }
       // payable(msg.sender).transfer(refund);
    }

    function auctionEnd() public payable onlyAfter(revealEnd) {
        require(!ended);
        emit AuctionEnded(highestBidder, highestBid);
        ended = true; 
        beneficiary.transfer(highestBid * (1 ether));
    }


    function withdraw() public {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0){
            pendingReturns[msg.sender] = 0;

            payable(msg.sender).transfer(amount);
        }
    }


    function placeBid(address bidder, uint value) internal returns(bool success){
        if (value<= highestBid){
            return false;
        }
        if (highestBidder != address(0)) { 
            //address(0) = 0x00000000 
            pendingReturns[highestBidder]+= highestBid;
        }
        highestBid = value;
        highestBidder = bidder;
        return true;
     }



}
