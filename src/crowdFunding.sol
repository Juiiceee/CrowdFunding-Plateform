// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract crowd {
	struct campagne {
		string name;
		string desc;
		uint256 nbEtherRequired;
		uint256 nbEther;
		uint256 nbDays;
		address owner;
		bool finish;
	}

	campagne[] public _tabCamp;
	uint256 public _index;

	mapping(uint256 => mapping(address => uint256)) public checkHistory;

	modifier isIndex(uint256 index) {
		require(index < _tabCamp.length, "Out of bound");
		_;
	}

	modifier isFinish(uint256 index) {
		require(_tabCamp[index].finish == false, "Out of bound");
		_;
	}

	modifier isCampagneOwner(uint256 index) {
		require(_tabCamp[index].owner == msg.sender, "You aren't the campagne owner");
		_;
	}

	modifier isPassed(uint256 index) {
		require(_tabCamp[index].nbEther + msg.value <= _tabCamp[index].nbEtherRequired, "A lot thune");
		_;
	}

	modifier isGood(uint256 index) {
		require(_tabCamp[index].nbEther == _tabCamp[index].nbEtherRequired, "not enought thune");
		_;
	}

	function createCampagne(string memory name, string memory desc, uint256 nbEther, uint256 nbDays) public {
		_tabCamp.push(campagne(name, desc, nbEther, 0, nbDays, msg.sender, false));
		_index++;
	}

	function viewCampagne(uint256 index)
		public
		view
		isIndex(index)
		returns (string memory, string memory, uint256, uint256, uint256, address, bool)
	{
		return (
			_tabCamp[index].name,
			_tabCamp[index].desc,
			_tabCamp[index].nbEtherRequired,
			_tabCamp[index].nbEther,
			_tabCamp[index].nbDays,
			_tabCamp[index].owner,
			_tabCamp[index].finish
		);
	}

	function contributeCampagne(uint256 index) public payable isIndex(index) isPassed(index) isFinish(index) {
		checkHistory[index][msg.sender] += msg.value;
		_tabCamp[index].nbEther += msg.value;
	}

	function withdraw(uint256 index) public isIndex(index) isGood(index) isFinish(index) {
		uint256 valeurwei = _tabCamp[index].nbEtherRequired * 1 ether;
		payable(msg.sender).transfer(valeurwei);
		_tabCamp[index].finish = true;
	}
}
