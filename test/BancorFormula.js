var BancorFormula = artifacts.require("BancorFormula");
const BN = web3.BigNumber;
const TWO_X_FIXED_1 = new BN("0x100000000000000000000000000000000")

var printPow = (output) => {
  return output[0].div(new BN("0x02").pow(output[1])).toNumber()
}

contract('BancorFormula', function(accounts) {

  // it("should compute the half life in seconds", function() {
  //   return BancorFormula.new({from: accounts[0]}).then((_instance) => {
  //     instance = _instance
  //   // return BancorFormula.deployed().then(function(instance) {
  //     // return instance.expFloor.call(10, 100)
  //     // return instance.fracExp.call(10, 100, 3, 2)
  //     // console.log("HERE", TWO_X_FIXED_1.toNumber() , "THERE")
  //     // 1.01^567
  //     // 1234580235/1234567890^980600/1000000 ~= 
  //     var _baseN = 1234580235
  //     var _baseD = 1234
  //     var _expN  = 980600
  //     var _expD  = 1000000
  //     console.log("one")
  //     return instance.power(_baseN, _baseD, _expN, _expD)
  //   }).then(function(output) {
  //     var out  = output[0]
  //     var prec = output[1]
  //     console.log("estimate: ", out.toNumber(), "precision: ", prec.toNumber());
  //     console.log("full implication: ", printPow(output))
  //   //   return instance.fracExp.sendTransaction(1000000000, 68245410, 47304000, 250,{from: accounts[0], gas: 700000})
  //   // }).then(function(txHash) {
  //   //   console.log("txHash:", txHash);
  //   //   return web3.eth.getTransactionReceipt(txHash)
  //   // }).then(function(receipt) {
  //   //   console.log("receipt:", receipt)
  //     // assert.equal(output.valueOf(), 2000000, " wasn't in the first account");
  //   });
  // });

  // it("should compute all purchase returns", function() {
  //   var _supply = 1234
  //   var _connectorBalance =  1235
  //   var _connectorWeight = 1236
  //   var _depositAmount = 123700
  //   return BancorFormula.new({from: accounts[0]}).then((_instance) => {
  //     return instance.calculatePurchaseReturn( _supply, _connectorBalance, _connectorWeight, _depositAmount)
  //   }).then(function(output) {
  //     console.log("calculatePurchaseReturn:", output.toNumber()); // 7
  //   });
  // });
  // it("should compute all purchase returns", function() {
  //   var _supply = 1234
  //   var _connectorBalance =  1235
  //   var _connectorWeight = 723600
  //   var _depositAmount = 123700
  //   return BancorFormula.new({from: accounts[0]}).then((_instance) => {
  //     return instance.calculatePurchaseReturn( _supply, _connectorBalance, _connectorWeight, _depositAmount)
  //   }).then(function(output) {
  //     console.log("calculatePurchaseReturn:", output.toNumber());
  //   });
  // });
  // it("should compute all purchase returns", function() {
  //   //column 7
  //   var _supply = 1137846
  //   var _connectorBalance =  1171561
  //   var _connectorWeight = 943551
  //   var _depositAmount = 1000000
  //   return BancorFormula.new({from: accounts[0]}).then((_instance) => {
  //     return instance.calculatePurchaseReturn( _supply, _connectorBalance, _connectorWeight, _depositAmount)
  //   }).then(function(output) {
  //     console.log("calculatePurchaseReturn:", output.toNumber());
  //     // 899017
  //     expect(output.toNumber()).to.be.closeTo(899017, 3);
  //   });
  // });

  it("should compute all sale returns", async() => {

    let instance = await BancorFormula.new({from: accounts[0]});

    var _supply = 2036862
    var _connectorBalance =  2049767
    var _connectorWeight = 890631
    var _amount = 1962594
    let output = await instance.calculateSaleReturn( _supply, _connectorBalance, _connectorWeight, _amount);
    expect(output.toNumber()).to.be.closeTo(2000000, 2);

    _supply = 74269
    _connectorBalance =  48819
    _connectorWeight = 873659
    _amount = 358796

    output = await instance.calculatePurchaseReturn( _supply, _connectorBalance, _connectorWeight, _amount);
    expect(output.toNumber()).to.be.closeTo(400000, 2);

    console.log("calculatePurchaseReturn2:", output.toNumber());

  });

  // test the gas cost of "reserveRatio_x_E6()". if its more than 5000 we should think about optimizing

});







