const HELLO_WORLD = artifacts.require("./HelloWorld.sol")

module.exports = function(deployer) {
	deployer.deploy(HELLO_WORLD);
};

