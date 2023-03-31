// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.18;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol"; 
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol"; 
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol"; 

contract CrowdFunding is OwnableUpgradeable, ReentrancyGuardUpgradeable { 
    struct Campaign { 
        address creator; 
        uint goal; 
        uint pledged; 
        uint32 startAt; 
        uint32 endAt; 
        bool IsClaimed; 
    }

    IERC20Upgradeable public token;
    uint public count;
    mapping (uint => Campaign) public campaigns;
    mapping (uint => mapping(address => uint)) public pledgedAmount;

    event Launch(
        uint id,
        address indexed creator,
        uint goal,
        uint32 startAt,
        uint32 endAt
    );

    event Cancel(uint id);
    event Claim(uint id);
    event Refund(uint indexed id, address indexed caller, uint amount);
    event Pledge(uint indexed id, address indexed caller, uint amount);
    event Unpledge(uint indexed id, address indexed caller, uint amount);

    function initialize(address _token) public initializer {
        __Ownable_init();

        token = IERC20Upgradeable(_token);
    }

    modifier onlyCreator(uint _id) {
        require(msg.sender == campaigns[_id].creator, "Not the Creator.");
        _;
    }

    modifier campaignNotStarted(uint _id) {
        require(block.timestamp < campaigns[_id].startAt, "Already started.");
        _;
    }

    modifier campaignEnded(uint _id) {
        require(block.timestamp > campaigns[_id].endAt, "Campaign not ended yet.");
        _;
    }

    modifier withinCampaignDuration(uint _id) {
        require(block.timestamp >= campaigns[_id].startAt, "Campaign has not started yet.");
        require(block.timestamp <= campaigns[_id].endAt, "Campaign has ended.");
        _;
    }

    function launch(
        uint _goal,
        uint32 _startAt,
        uint32 _endAt
    ) external {
        require(_startAt >= block.timestamp, "Start date is in the past.");
        require(_endAt >= _startAt, "End date is less than start date");
        require(_endAt <= block.timestamp + 90 days, "End date is larger than max duration");

        count +=1;
        campaigns[count] = Campaign({
            creator: msg.sender,
            goal: _goal,
            pledged: 0,
            startAt: _startAt,
            endAt: _endAt,
            IsClaimed: false
        });

        emit Launch(count, msg.sender, _goal, _startAt, _endAt);
    }

    function cancel (uint _id) external onlyCreator(_id) campaignNotStarted(_id) {
        delete campaigns[_id];
        emit Cancel(_id);
    }

    function pledge (uint _id, uint _amount) external payable withinCampaignDuration(_id) nonReentrant {
        Campaign storage campaign = campaigns[_id];
        campaign.pledged += _amount;
        pledgedAmount[_id][msg.sender] += _amount;
        token.transferFrom(msg.sender, address(this), _amount);

        emit Pledge(_id, msg.sender, _amount);
    }

    function unpledge (uint _id, uint _amount) external withinCampaignDuration(_id) nonReentrant {
        Campaign storage campaign = campaigns[_id];
        campaign.pledged -= _amount;
        pledgedAmount[_id][msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);

        emit Unpledge(_id, msg.sender, _amount);
    }

    function claim (uint _id) external onlyCreator(_id) campaignEnded(_id) nonReentrant {
        Campaign storage campaign = campaigns[_id];
        require(campaign.pledged >= campaign.goal, "Pledged amount is less than the goal.");
        require(!campaign.IsClaimed, "Campaign already claimed.");

        campaign.IsClaimed = true;
        token.transfer(msg.sender, campaign.pledged);

        emit Claim(_id);
    }

    function refund (uint _id) external campaignEnded(_id) nonReentrant {
        Campaign storage campaign = campaigns[_id];
        require(campaign.pledged < campaign.goal, "Pledged amount is greater than or equal to the goal.");

        uint bal = pledgedAmount[_id][msg.sender];
        pledgedAmount[_id][msg.sender]=0;
        token.transfer(msg.sender, bal);

        emit Refund(_id, msg.sender, bal);
    }
}