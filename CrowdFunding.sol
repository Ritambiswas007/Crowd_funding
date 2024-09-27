// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaing{
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string images;
        address[] donators;
        uint256[] donations;

    }
    mapping(uint256 => Campaing) public campaings; // mapping of ids of campanigs 


    uint256 public numberOfCampiangs=0;


    function createCampaign(
        address _owner,
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadline,
        uint256 _amountCollected,
        string memory _images
        ) public returns (uint256){
        Campaing storage campaing=campaings[numberOfCampiangs];
        require(campaing.deadline< block.timestamp,"The deadline should be a date in the future");

        campaing.owner=_owner;
        campaing.title=_title;
        campaing.description=_description;
        campaing.target=_target;
        campaing.deadline=_deadline;
        campaing.amountCollected=_amountCollected;
        campaing.images=_images;

        numberOfCampiangs++;

        return numberOfCampiangs-1;//index of the most recently made campaing




    }
    

    function donateToCampiang(uint256 _id) public payable {
        uint256 amount=msg.value;
        Campaing storage campaing=campaings[_id];
        campaing.donators.push(msg.sender);
        campaing.donations.push(amount);
        (bool sent,)=payable(campaing.owner).call{value:amount}("");
        if(sent){
            campaing.amountCollected=campaing.amountCollected +amount;
        }

    }


    function getDonators(uint256 _id) view public returns (address[] memory,uint256[] memory){
        return (campaings[_id].donators,campaings[_id].donations);

    }

    function getCampaings() public view returns (Campaing[] memory){
        Campaing[] memory allCampiangs=new Campaing[](numberOfCampiangs);  //we just created an array of type Campaings[] with the size of number of Campaings

        for(uint i=0;i<numberOfCampiangs;i++){
            Campaing storage item=campaings[i];

            allCampiangs[i]=item;
        }
        return allCampiangs;

    }
}
