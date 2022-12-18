 //https://goerli.etherscan.io/tx/0xedcb55321c623083af511a7b247af1fcd516ff65a3e02959920eaff395b63f24
 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.6.0/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.6.0/access/Ownable.sol";

	pragma experimental ABIEncoderV2;

	contract VIPToken is ERC20, Ownable {

	event functionDone(string);
	enum State {DISABLED, ENABLED, DONE} State s; 
	struct Element{
		string ID;
		State status;
	}
	struct StateMemory{
	    address VIPaddress;
	    bool terminate;
    }
	Element[9] elements;
	StateMemory currentMemory;
	string[2] roleList = [ "Issuer", "Reciever" ]; 
	mapping(string=>address payable) roles; 

    constructor() ERC20("VIPToken", "VIPT"){
        //_mint(msg.sender, 1000000 * 10 ** decimals());
        elements[1] = Element("StartEvent", State.ENABLED);
         //roles definition
         //mettere address utenti in base ai ruoli
	    roles["Issuer"] = payable(0x0673e19E10bbE0E7d097C67926eC605B58eF8A76);
	    roles["undefined"] = payable(0x0673e19E10bbE0E7d097C67926eC605B58eF8A76);
		//enable the start process
		StartEvent();
		emit functionDone("Contract creation");
	}

    //function mint(address to, uint256 amount) public onlyOwner {
    //    _mint(to, amount);
    //}

    modifier checkRole(string memory role){ 
	    require(msg.sender == roles[role]);
        _; 
    } 

    function getRoles() public view returns( string[] memory, address[] memory){
        uint c = roleList.length;
        string[] memory allRoles = new string[](c);
        address[] memory allAddresses = new address[](c);
        
        for(uint i = 0; i < roleList.length; i ++){
            allRoles[i] = roleList[i];
            allAddresses[i] = roles[roleList[i]];
        }
        return (allRoles, allAddresses);
    }

    fallback() external payable {}

    function StartEvent() private {
        require(elements[1].status==State.ENABLED);
        done(1);
        enable("SaveVIPAddress",2);
    }

    function SaveVIPAddress(address VIPaddress) public checkRole(roleList[0]) {
        require(elements[2].status==State.ENABLED);  
        done(2);
        currentMemory.VIPaddress=VIPaddress;
        enable("ExclusiveGateway1",3);
        ExclusiveGateway1(); 
    }

    function RevokeVIPToken(bool terminate) public checkRole(roleList[0]) {
        require(elements[4].status==State.ENABLED);  
        done(4);
        currentMemory.terminate=terminate;
        enable("ExclusiveGateway2",5);
        ExclusiveGateway2(); 
    }

    function AcceptVIPToken(bool terminate) public checkRole(roleList[1]){
        require(elements[6].status==State.ENABLED);
        done(6);
        currentMemory.terminate=terminate;
        enable("RevokeVIPToken",4);
    }

    function ExclusiveGateway1() private {
        require(elements[3].status==State.ENABLED);
        done(3);
        enable("GiveVIPToken", 7);  
    }

    function GiveVIPToken(bool terminate) public checkRole(roleList[0]) {
        require(elements[7].status==State.ENABLED);  
        done(7);
        currentMemory.terminate=terminate;
        enable("AcceptVIPToken",6);
    }

    function EndEvent() private {
        require(elements[8].status==State.ENABLED);
        done(8);  
    }

    function ExclusiveGateway2() private {
        require(elements[5].status==State.ENABLED);
        done(5);
        if(currentMemory.terminate == true){
            enable("EndEvent", 8); 
            EndEvent(); 
        }
        else if(currentMemory.terminate == false){
            enable("ExclusiveGateway1", 3); 
            disable(4);
            disable(5);
            disable(6);
            disable(7);
            ExclusiveGateway1(); 
        }
    }

	function enable(string memory _taskID, uint position) internal {
		elements[position] = Element(_taskID, State.ENABLED);
	}

    function disable(uint elementNum) internal {
		elements[elementNum].status=State.DISABLED; 
    }

    function done(uint elementNum) internal {
 		elements[elementNum].status=State.DONE;
        emit functionDone(elements[elementNum].ID);
	}
   
    function getCurrentState()public view  returns(Element[9] memory, StateMemory memory){
        // emit stateChanged(elements, currentMemory);
        return (elements, currentMemory);
    }
    
    function compareStrings (string memory a, string memory b) internal pure returns (bool) { 
        return keccak256(abi.encode(a)) == keccak256(abi.encode(b)); 
    }
}