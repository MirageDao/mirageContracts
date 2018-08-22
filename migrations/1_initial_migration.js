var Migrations = artifacts.require("./Migrations.sol");
var Bancor = artifacts.require("./Bancor.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(Bancor);
};
