var Pow = artifacts.require("Pow");

contract('Pow', function(accounts) {
  var instance
  it("should compute the half life in seconds", function() {
    return Pow.new({from: accounts[0]}).then((_instance) => {
      instance = _instance
    // return Pow.deployed().then(function(instance) {
      // return instance.expFloor.call(10, 100)
      // return instance.fracExp.call(10, 100, 3, 2)
      return instance.fracExp.call(           1000000000, 68245410, 47304000, 250,{from: accounts[0], gas: 700000})
    }).then(function(ouput) {
      console.log("ouput:", ouput.toNumber());
      return instance.fracExp.sendTransaction(1000000000, 68245410, 47304000, 250,{from: accounts[0], gas: 700000})
    }).then(function(txHash) {
      console.log("txHash:", txHash);
      return web3.eth.getTransactionReceipt(txHash)
    }).then(function(receipt) {
      console.log("receipt:", receipt)
      // assert.equal(output.valueOf(), 2000000, " wasn't in the first account");
    });
  });

  it("should compute all exponentials for the first 3 years without significant errors", function() {
    var timeSinceCreated
    return Pow.new({from: accounts[0]}).then((_instance) => {
      let instance = _instance
    // return Pow.deployed().then(function(instance) {
      // return instance.expFloor.call(10, 100)
      // return instance.fracExp.call(10, 100, 3, 2)


      var promiseMaker = (i) => { 
        return instance.fracExp.call(1000000000, 68245410, i, 16,{from: accounts[0], gas: 700000})
        return new Promise((resolve, reject) => {
          console.log(i)
          resolve();
        })
      }

      var tempFuncPromise = promiseMaker(0);
      var results = [];
      for (var i = 1; i < 5; i++) {
        let j = i
        tempFuncPromise.then( function( result ) {
          console.log(result.toNumber())
          results.push( result );
          tempFuncPromise = promiseMaker(j*10000000);
          if(results.length == 5) console.log("DONE")
        })
      }
      // return tempFuncPromise



      // var chain = new Promise(function(resolve, reject) {
      //   console.log("zeroith promise")
      //   resolve(1);
      // })

      // for(var i = 0; i < 5; i++) {
      //   chain = chain.then(function(_ret) {
      //     ret = _ret
      //     return fracExp.call(1000000000, 68245410, ret, 16,{from: accounts[0], gas: 700000})
      //     // }).then(function(ouput) {
      //     //   console.log("ouput:", ouput.toNumber());
      //     if (ret%1 == 0) console.log("promise: ", ret)
      //     return fracExp.call(1000000000, 68245410, ret, 16,{from: accounts[0], gas: 700000})//ret+1
      //   })
      // }

      // chain("arg0");


      return instance.fracExp.call(           1000000000, 68245410, 47304000, 250,{from: accounts[0], gas: 700000})
    }).then(function(output) {
      console.log("ouput:", output);
    });
  });

});

