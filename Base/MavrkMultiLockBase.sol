// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface INonfungiblePositionManager {
    struct CollectParams {
        uint256 tokenId;
        address recipient;
        uint128 amount0Max;
        uint128 amount1Max;
    }

    function ownerOf(uint256 tokenId) external view returns (address);
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function collect(CollectParams calldata params) external payable returns (uint256 amount0, uint256 amount1);
}

contract MavrkMultiLockBNB {
    INonfungiblePositionManager public immutable npm;
    address public constant MAVRK_MAIN_DEPLOYER = 0xa7597ded779806314544CBDabd1f38DE290677A2;
    address public constant TREASURY = 0x9f2cc0Af4cFCe8a65a08E103bd52AcB608E6948C;

    mapping(uint256 => bool) public lockedLPs;
    mapping(uint256 => address) public lpLockers;
    uint256[] public lpTokenIds;

    event LPTokenLocked(uint256 indexed tokenId, address indexed locker);
    event FeesCollected(uint256 indexed tokenId, uint256 amount0, uint256 amount1);

    constructor(address _npm) {
        require(_npm != address(0), "Invalid NPM address");
        npm = INonfungiblePositionManager(_npm);
    }

    function lockLP(uint256 tokenId) external {
        require(!lockedLPs[tokenId], "LP already locked");
        address self = address(this);
        npm.safeTransferFrom(msg.sender, self, tokenId);
        require(npm.ownerOf(tokenId) == self, "Transfer to locker failed");
        lockedLPs[tokenId] = true;
        lpTokenIds.push(tokenId);
        lpLockers[tokenId] = msg.sender;
        emit LPTokenLocked(tokenId, msg.sender);
    }

    function lock(uint256 tokenId) external {
        require(!lockedLPs[tokenId], "LP already locked");
        require(npm.ownerOf(tokenId) == address(this), "NFT not owned by contract");
        lockedLPs[tokenId] = true;
        lpTokenIds.push(tokenId);
        lpLockers[tokenId] = msg.sender;
        emit LPTokenLocked(tokenId, msg.sender);
    }

    function collectFees(uint256 tokenId) external {
        require(msg.sender == MAVRK_MAIN_DEPLOYER, "Unauthorized");
        INonfungiblePositionManager.CollectParams memory params = INonfungiblePositionManager.CollectParams({
            tokenId: tokenId,
            recipient: TREASURY,
            amount0Max: type(uint128).max,
            amount1Max: type(uint128).max
        });
        (uint256 amount0, uint256 amount1) = npm.collect(params);
        emit FeesCollected(tokenId, amount0, amount1);
    }

    function collectAllFees() external {
        require(msg.sender == MAVRK_MAIN_DEPLOYER, "Unauthorized");
        for (uint256 i = 0; i < lpTokenIds.length; i++) {
            uint256 tokenId = lpTokenIds[i];
            INonfungiblePositionManager.CollectParams memory params = INonfungiblePositionManager.CollectParams({
                tokenId: tokenId,
                recipient: TREASURY,
                amount0Max: type(uint128).max,
                amount1Max: type(uint128).max
            });
            (uint256 amount0, uint256 amount1) = npm.collect(params);
            emit FeesCollected(tokenId, amount0, amount1);
        }
    }

    function getLockedLPCount() external view returns (uint256) {
        return lpTokenIds.length;
    }

    function getLockedLPs() external view returns (uint256[] memory) {
        return lpTokenIds;
    }

    function getLocker(uint256 tokenId) external view returns (address) {
        return lpLockers[tokenId];
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure returns (bytes4) {
        return this.onERC721Received.selector;
    }
}