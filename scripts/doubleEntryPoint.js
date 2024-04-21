jsonInterface = {
   type:"function",
   name:"setDetectionBot",
   inputs: [{
       name: "detectionBotAddress",
       type: "address"
   }]
}
botAddress = "your bot address"
parameters = [botAddress]
encodedFunctionCall = web3.eth.abi.encodeFunctionCall(jsonInterface, parameters)

await web3.eth.sendTransaction({ from: await contract.player(), to: await contract.forta(), data: encodedFunctionCall});