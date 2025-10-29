pragma solidity ^0.8.0;

contract ChainMemory {
    struct Match {
        address player;
        string gameState;
        uint256 timestamp;
    }

    Match[] public matches;
    mapping(address => uint256[]) public playerMatches;

    event MatchStored(address indexed player, uint256 matchId, string gameState);

    function storeMatch(string calldata _gameState) external {
        Match memory newMatch = Match({
            player: msg.sender,
            gameState: _gameState,
            timestamp: block.timestamp
        });

        matches.push(newMatch);
        uint256 matchId = matches.length - 1;
        playerMatches[msg.sender].push(matchId);

        emit MatchStored(msg.sender, matchId, _gameState);
    }

    function getPlayerMatches(address _player) external view returns (uint256[] memory) {
        return playerMatches[_player];
    }

    function getMatch(uint256 _matchId) external view returns (address, string memory, uint256) {
        require(_matchId < matches.length, "Invalid match ID");
        Match memory m = matches[_matchId];
        return (m.player, m.gameState, m.timestamp);
    }

    function totalMatches() external view returns (uint256) {
        return matches.length;
    }
}
