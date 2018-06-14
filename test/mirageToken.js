var MirageToken = artifacts.require("MirageToken");

contract('MirageToken', function(accounts) {
  var inst // contract instance
  it("should compute the half life in seconds", function() {
    return MirageToken.new({from: accounts[0]}).then((_inst) => {
      inst = _inst
      return inst.fracExp(1000000, 68245410, 73045000, 6)
    }).then(function(output) {
      console.log("output:", output, "\n", output.toNumber()/1000000);
    //   return inst.fracExp.sendTransaction(1000000000, 68245410, 47304000, 250,{from: accounts[0], gas: 700000})
    // }).then(function(txHash) {
    //   console.log("txHash:", txHash);
    //   return web3.eth.getTransactionReceipt(txHash)
    // }).then(function(receipt) {
    //   console.log("receipt:", receipt)
    });
  });

  // it("should compute all exponentials for the first 3 years without significant errors", function() {
  //   var timeSinceCreated
  //   return MirageToken.new({from: accounts[0]}).then((_inst) => {
  //     let inst = _inst
  //   // return MirageToken.deployed().then(function(inst) {
  //     // return inst.expFloor.call(10, 100)
  //     // return inst.fracExp.call(10, 100, 3, 2)


  //     var promiseMaker = (i) => { 
  //       return inst.fracExp.call(1000000000, 68245410, i, 16,{from: accounts[0], gas: 700000})
  //       return new Promise((resolve, reject) => {
  //         console.log(i)
  //         resolve();
  //       })
  //     }

  //     var tempFuncPromise = promiseMaker(0);
  //     var results = [];
  //     for (var i = 1; i < 5; i++) {
  //       let j = i
  //       tempFuncPromise.then( function( result ) {
  //         console.log(result.toNumber())
  //         results.push( result );
  //         tempFuncPromise = promiseMaker(j*10000000);
  //         if(results.length == 5) console.log("DONE")
  //       })
  //     }

  //     return inst.fracExp.call(           1000000000, 68245410, 47304000, 250,{from: accounts[0], gas: 700000})
  //   }).then(function(output) {
  //     console.log("output:", output);
  //   });
  // });

});

