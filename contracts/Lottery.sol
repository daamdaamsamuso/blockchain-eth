// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Lottery {
    struct BetInfo {
        //answer block
        uint256 answerBlockNumber;
        //send answer block address
        address payable bettor;
        //0xab..
        byte challenges;
    }
    uint256 private _tail;
    uint256 private _head;
    mapping(uint256 => BetInfo) private _bets;

    address public owner;

    uint256 internal constant BLOCK_LIMIT = 256;
    uint256 internal constant BET_BLOCK_INTERNAL = 3;
    uint256 internal constant BET_AMOUNT = 5 * 10**15;

    uint256 private _pot;

    event BET(
        uint256 index,
        address bettor,
        uint256 amount,
        byte challenges,
        uint256 answerBlockNumber
    );

    constructor() public {
        owner = msg.sender;
    }

    function getPot() public view returns (uint256 pot) {
        return _pot;
    }

    /**
     * @dev 배팅을 한다. 유저는 0.005이더를 보내야하고, 배팅을 1byte 글자를 보낸다.
     * 큐에 저장된 베팅 정보는 이후 distribute 함수에서 해결된다.
     * @param challenges 유저가 셋팅하는 글자
     * @return result 함수가 잘 수행되었는지 확인하는 bool 값
     */
    function bet(byte challenges) public payable returns (bool result) {
        require(msg.value == BET_AMOUNT, "Not enouth ETH");
        require(pushBet(challenges), "Fail to add a new Bet Info");
        emit BET(
            _tail - 1,
            msg.sender,
            msg.value,
            challenges,
            block.number + BET_BLOCK_INTERNAL
        );
        return true;
    }

    function getBetInfo(uint256 index)
        public
        view
        returns (
            uint256 answerBlockNumber,
            address bettor,
            byte challenges
        )
    {
        BetInfo memory b = _bets[index];
        answerBlockNumber = b.answerBlockNumber;
        bettor = b.bettor;
        challenges = b.challenges;
    }

    function pushBet(byte challenges) internal returns (bool) {
        BetInfo memory b;
        b.bettor = msg.sender;
        b.answerBlockNumber = block.number + BET_BLOCK_INTERNAL;
        b.challenges = challenges;

        _bets[_tail] = b;
        _tail++;

        return true;
    }

    function popBet(uint256 index) internal returns (bool) {
        delete _bets[index];
        return true;
    }
}
