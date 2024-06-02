// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract crowd {
	struct campagne {
		string	name;
		string	desc;
		uint256	nbEther;
		uint256	nbDays;
		address	owner;
	}

	campagne[] public	_tabCamp;
	uint public			_index;

	modifier isIndex(uint index)
	{
		require(index < _tabCamp.length, "Out of bound");
		_;
	}

	function createCampagne
	(
		string memory	_name,
		string memory	_desc,
		uint256			_nbEther,
		uint256			_nbDays
	) public
	{
		_tabCamp.push(campagne(_name, _desc, _nbEther, _nbDays, msg.sender));
		_index++;
	}


}
