
const { deployProxy, upgradeProxy } = require('@openzeppelin/truffle-upgrades');

var SocialNetworkToken = artifacts.require('./SocialNetworkToken');

module.exports = async function(deployer) {
    try {
        var instance = await SocialNetworkToken.deployed();
        var upgraded = await upgradeProxy(instance.address, SocialNetworkToken, { deployer });
        console.log("Upgraded", upgraded.address);    
    } catch(error) {
        var instance = await deployProxy(SocialNetworkToken, [], { deployer });
        console.log("Deployed", instance.address);    
    }
}