var CatecoinIssuance = artifacts.require("./CatecoinIssuance.sol");
var Catecoin = artifacts.require("./Catecoin.sol");
var StandardToken = artifacts.require("./token/StandardToken.sol");
var BasicToken = artifacts.require("./token/BasicToken.sol");
var ERC20 = artifacts.require("./token/ERC20.sol");
var ERC20Basic = artifacts.require("./token/ERC20Basic.sol");

module.exports = function(deployer) {
    deployer.deploy(CatecoinIssuance);
};
