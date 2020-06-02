pragma solidity >=0.5.0;

import "./owned.sol";
import "./ERC20.sol";

contract DeliverToken is owned{
    
    struct DeliverSetting {
        address wallet;
        uint256 amount;
        bool isOneTime;
    }
    
    mapping(address=>DeliverSetting) public DeliverInfo;
    mapping(address=>mapping(address=>bool)) public DeliverRecord; 
    
    function addDeliverSetting(address token_addr,
                            address wallet,
                            uint256 amount,
                            bool isOneTime)
                            external
                            onlyOwner{
        require(ERC20(token_addr).totalSupply()>0, "not a token address");
        require(amount > 0, "should be more than zero");
        DeliverInfo[token_addr] = DeliverSetting(wallet, amount, isOneTime);                            
    }
    
    function getFreeToken(address token_addr) external {
        DeliverSetting memory settings = DeliverInfo[token_addr];
        if (settings.isOneTime){
            require(DeliverRecord[token_addr][msg.sender]==false, "already applied");
            DeliverRecord[token_addr][msg.sender] = true;
        }
        ERC20(token_addr).transferFrom(settings.wallet, msg.sender, settings.amount);
    }
}