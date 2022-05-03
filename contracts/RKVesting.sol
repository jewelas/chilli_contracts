// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Context.sol";
import "./SafeMath.sol";
import "./Ownable.sol";
import "./IRaceKingdom.sol";

contract RKVesting is Context, Ownable {
    using SafeMath for uint256;

    event Released(uint256 fundId, uint256 amount);

    mapping(uint256 => uint256[]) private _vestingAmount;
    mapping(uint256 => address) private _beneficiary;
    mapping(uint256 => uint256) private released;
    mapping(uint256 => uint256) private allocation;

    uint256 private constant _seedRound = 1;
    uint256 private constant _privateRound = 2;
    uint256 private constant _publicRound = 3;
    uint256 private constant _team = 4;
    uint256 private constant _advisors = 5;
    uint256 private constant _p2e = 6;
    uint256 private constant _staking = 7;
    uint256 private constant _ecosystem = 8;

    bool private _isTriggered;

    uint256 private _start;

    IRaceKingdom _racekingdom;


    constructor (address RaceKingdomAddr) {
        _racekingdom = IRaceKingdom(RaceKingdomAddr);
        _isTriggered = false;
        allocation[_seedRound] = 296000000;
        allocation[_privateRound] = 444000000;
        allocation[_publicRound] = 148000000;
        allocation[_team] = 555000000;
        allocation[_advisors] = 185000000;
        allocation[_p2e] = 1110000000;
        allocation[_staking] = 555000000;
        allocation[_ecosystem] = 407000000;
    }

    function SeedRoundVestingAmount () external view onlyOwner returns (uint256[] memory) {
        return(_vestingAmount[_seedRound]);
    }

    function seedRoundBeneficiary() public view returns (address) {
        return _beneficiary[_seedRound];
    }

    function SetSeedRoundVestingAmount (uint256[] memory vestingAmount) public onlyOwner returns (bool) {
        _vestingAmount[_seedRound] = vestingAmount;
        return true;
    }

    function setSeedRoundBeneficiary (address beneficiary) public onlyOwner returns (bool) {
        _beneficiary[_seedRound] = beneficiary;
        return true;
    }

    function PrivateRoundVestingAmount () external view onlyOwner returns ( uint256[] memory) {
        return( _vestingAmount[_privateRound]);
    }

    function privateRoundBeneficiary() public view returns (address) {
        return _beneficiary[_privateRound];
    }

    function SetPrivateRoundVestingAmount (uint256[] memory vestingAmount) public onlyOwner returns (bool) {
        _vestingAmount[_privateRound] = vestingAmount;
        return true;
    }

    function setPrivateRoundBeneficiary (address beneficiary) public onlyOwner returns (bool) {
        _beneficiary[_privateRound] = beneficiary;
        return true;
    }

    function PublicRoundVestingAmount () external view onlyOwner returns (uint256[] memory) {
        return(_vestingAmount[_publicRound]);
    }

    function publicRoundBeneficiary() public view returns (address) {
        return _beneficiary[_publicRound];
    }

    function SetPublicRoundVestingAmount (uint256[] memory vestingAmount) public onlyOwner returns (bool) {
        _vestingAmount[_publicRound] = vestingAmount;
        return true;
    }

    function setPublicRoundBeneficiary (address beneficiary) public onlyOwner returns (bool) {
        _beneficiary[_publicRound] = beneficiary;
        return true;
    }

    function TeamVestingAmount () external view onlyOwner returns (uint256[] memory) {
        return(_vestingAmount[_team]);
    }

    function teamBeneficiary() public view returns (address) {
        return _beneficiary[_team];
    }

    function SetTeamVestingAmount (uint256[] memory vestingAmount) public onlyOwner returns (bool) {
        _vestingAmount[_team] = vestingAmount;
        return true;
    }

    function setTeamBeneficiary (address beneficiary) public onlyOwner returns (bool) {
        _beneficiary[_team] = beneficiary;
        return true;
    }

    function AdvisorsVestingAmount () external view onlyOwner returns (uint256[] memory) {
        return(_vestingAmount[_advisors]);
    }

    function advisorsBeneficiary() public view returns (address) {
        return _beneficiary[_advisors];
    }

    function SetAdvisorsVestingAmount (uint256[] memory vestingAmount) public onlyOwner returns (bool) {
        _vestingAmount[_advisors] = vestingAmount;
        return true;
    }

    function setAdvisorsBeneficiary (address beneficiary) public onlyOwner returns (bool) {
        _beneficiary[_advisors] = beneficiary;
        return true;
    }

    function P2EVestingAmount () external view onlyOwner returns (uint256[] memory) {
        return(_vestingAmount[_p2e]);
    }

    function p2eBeneficiary() public view returns (address) {
        return _beneficiary[_p2e];
    }

    function SetP2EVestingAmount (uint256[] memory vestingAmount) public onlyOwner returns (bool) {
        _vestingAmount[_p2e] = vestingAmount;
        return true;
    }

    function setP2EBeneficiary (address beneficiary) public onlyOwner returns (bool) {
        _beneficiary[_p2e] = beneficiary;
        return true;
    }

    function StakingVestingAmount () external view onlyOwner returns (uint256[] memory) {
        return(_vestingAmount[_staking]);
    }

    function stakingBeneficiary() public view returns (address) {
        return _beneficiary[_staking];
    }

    function SetStakingVestingAmount (uint256[] memory vestingAmount) public onlyOwner returns (bool) {
        _vestingAmount[_staking] = vestingAmount;
        return true;
    }

    function setStakingBeneficiary (address beneficiary) public onlyOwner returns (bool) {
        _beneficiary[_staking] = beneficiary;
        return true;
    }

    function EcosystemVestingAmount () external view onlyOwner returns (uint256[] memory) {
        return(_vestingAmount[_ecosystem]);
    }

    function ecosystemBeneficiary() public view returns (address) {
        return _beneficiary[_ecosystem];
    }

    function SetEcosystemVestingAmount (uint256[] memory vestingAmount) public onlyOwner returns (bool) {
        _vestingAmount[_ecosystem] = vestingAmount;
        return true;
    }

    function setEcosystemBeneficiary (address beneficiary) public onlyOwner returns (bool) {
        _beneficiary[_ecosystem] = beneficiary;
        return true;
    }

    function Trigger () public onlyOwner returns (bool) {
        require(!_isTriggered, "Already triggered");
        _isTriggered = true;
        _start = block.timestamp;
        return true;
    }

    function  Month () public view returns(uint256) {
        require(_isTriggered, "Not triggered yet");
        return getMonth(block.timestamp);
    }

    function getMonth (uint256 time) public view returns (uint256) {
        require(_isTriggered, "Not triggered yet");
        uint256 month = (time.sub(_start)).div(30 days).add(1);
        return month;
    } 

    function vestedAmount (uint256 fundId) public view returns (uint256) {
        uint256 vested = 0;
        for (uint256 i = 0; i < Month(); i.add(1)) {
            vested = vested.add(_vestingAmount[fundId][i]);
        }
        return vested;
    }

    function quarterVestingAmount (uint256 quarter) public view returns (uint256) {
        uint256 amount = 0;
        for (uint256 i = quarter.mul(3).sub(3); i < quarter.mul(3); i++){
            for(uint256 fundId = 1; fundId <= 8; fundId++) {
                amount = amount.add(_vestingAmount[fundId][i]);
            }
        }
        return amount;
    }

    function releasableAmount (uint256 fundId) public view returns (uint256) {
        return vestedAmount(fundId).sub(released[fundId]);
    }

    function releaseSeedRound() public onlyOwner returns (bool) {
        return _release(_seedRound);
    }

    function releasePrivateRound() public onlyOwner returns (bool) {
        return _release(_privateRound);
    }

    function releasePublicRound() public onlyOwner returns (bool) {
        return _release(_publicRound);
    }

    function releaseTeam() public onlyOwner returns (bool) {
        return _release(_team);
    }

    function releaseP2E() public onlyOwner returns (bool) {
        return _release(_p2e);
    }

    function releaseStaking() public onlyOwner returns (bool) {
        return _release(_staking);
    }

    function releaseEcosystem() public onlyOwner returns (bool) {
        return _release(_ecosystem);
    }

    function releaseAdvisors() public onlyOwner returns (bool) {
        return _release(_advisors);
    }

    function _release (uint256 fundId) internal onlyOwner returns (bool) {
        uint256 unreleased = releasableAmount(fundId);
        require(_isTriggered, "Not triggered yet");
        require(unreleased > 0, "No releasable amount");
        require(released[fundId].add(unreleased) <= allocation[fundId], "This release would exceed the allocated amount");
        require(_beneficiary[fundId] != address(0), "Beneficiary address not set");
        released[fundId] = released[fundId].add(unreleased);
        _racekingdom.transfer(_beneficiary[fundId], unreleased);
        return true;
    }
}

