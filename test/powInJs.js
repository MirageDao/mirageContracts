// uint256 can hold ~ 1e76
const BN = require('bn.js');
// problematic: a.a(1000000, 68245410, -73045000, 2) => -70328
var a =  (_k, _q, _n, _p) => { 
  let k = new BN(_k)
  let q = new BN(_q)
  let n = new BN(_n)
  let p = new BN(_p)

  let MAX = new BN("100000000000000000000000000000000000000000000000000000000000000",16)/*presentationMultiple, baseReciprical, seconds, rounds */
  let s = new BN(0)
  let N = new BN(1)
  let B = new BN(1)
  let bnu = new BN(0)
  var labels = ["k*N ", "k*N/B ", "k*N/B/(q**i) ", "N*(n-i) ", "B*(i+1) "]
  for (var i = 0; i < p; ++i){
    // console.log(i, " s: ", s, "N: ", N, "B: ", B, "q**i ", q**i)
    var data = [k.mul(N), k.mul(N).div(B), k.mul(N).div(B).div(q.pow(new BN(i))), N.mul(n.sub(new BN(i))), B.mul(new BN(i).add(new BN(1)))]
    for (var j = 0; j < labels.length; j++) {
      if(data[j].abs().gt(bnu.abs())) bnu = data[j].abs() //new BN(data[j])?
      if(data[j].abs().gt(MAX.abs())) console.log("ERROR in round ", i, ": ", labels[j], Number(data[j].toString()))
    }

    s = s.add(k.mul(N).div(B).div(q.pow(new BN(i))))
    N = N.mul(n.sub(new BN(i)))
    B = B.mul(new BN(i).add(new BN(1)))//waht if n is small and this becomes negative?

  }
  console.log("BiggestNumUsed: ", Number(bnu.toString()))
  // return bnu
  return s.toNumber() 
}

var b = findReversals = (k, q, n, p, rounds) => {
  var last = 0
  for (var i = 0; i < rounds; i++) {
    var current = a(k, q, n+i, p)
    if(current < last) {
      console.log("ERROR ", n+i, " ", n)
      return
    }
    last = current
  }
}

module.exports = {a,b, BN}
