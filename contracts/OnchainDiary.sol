// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OnchainDiary {
    struct Entry {
        uint256 timestamp;
        string content;
    }

    mapping(address => Entry[]) private diaries;
    mapping(address => uint256) public lastWrite;

    event NewEntry(address indexed user, uint256 timestamp, string content);

    uint256 public constant COOLDOWN = 1 days;

    function writeEntry(string calldata _content) external {
        require(bytes(_content).length > 0, "Empty content");

        require(
            block.timestamp >= lastWrite[msg.sender] + COOLDOWN,
            "Wait 24h"
        );

        diaries[msg.sender].push(
            Entry(block.timestamp, _content)
        );

        lastWrite[msg.sender] = block.timestamp;

        emit NewEntry(msg.sender, block.timestamp, _content);
    }

    function getMyEntries() external view returns (Entry[] memory) {
        return diaries[msg.sender];
    }

    function getEntryCount(address user) external view returns (uint256) {
        return diaries[user].length;
    }
}
