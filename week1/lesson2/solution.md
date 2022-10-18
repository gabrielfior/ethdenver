# Solution - Homework 2

>1 -  Using a blockchain explorer, have a look at the following transactions, what do they do?
>- 0x0ec3f2488a93839524add10ea229e773f6bc891b4eb4794c3337d4495263790b
>> That was the first transaction as part of the DAO Hack in 2016. It involved transferring a large amount of tokens from the DAOManagedAcct to a particular address (0xc0ee9db1a9e07ca63e4ff0d5fb6f86bf68d47b89). 
>- 0x4fc1580e7f66c58b7c26881cce0aab9c3509afe6e507527f30566fbf8039bcd0
>> Deployment of the UniswapV2 router.
>- 0x552bc0322d78c5648c5efa21d2daa2d0f14901ad4b15531f1ab5bbe5674de34f
>> Polynetwork exploit
>- 0x7a026bf79b36580bf7ef174711a3de823ff3c93c65304c3acc0323c77d62d0ed
>> Polynetwork exploit (transfer of 96M DAI to hacker's wallet)
>- 0x814e6a21c8eb34b62a05c1d0b14ee932873c62ef3c8575dc49bcf12004714eda
>> Polynetwork exploit (transfer of 160 ETH to a smart contract associated to the hacker)

>2 - What is the largest account balance you can find ?
>> Beacon deposit account (https://etherscan.io/address/0x00000000219ab540356cbb839cbe05303d7705fa). For a full list of accounts with corresponding balances -> https://etherscan.io/accounts

>3 - What is special about these accounts:
>- 0x1db3439a222c519ab44bb1144fc28167b4fa6ee6
>> Deposit address for validators to deposit their ETH to be staked and be able to validate transactions.
>- 0x000000000000000000000000000000000000dEaD
>> It's the null address. Like a black whole, all tokens sent to this address are burned and can never be retrieved again.

>Using Remix, compile contract and deploy it to Remix VM environment.
>> Deployed to 0xce64782CEf36130F754F2d5365f93cD024B6bc05 (Goerli testnet).