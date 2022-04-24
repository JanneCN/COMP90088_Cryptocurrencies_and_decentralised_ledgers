# 以太坊

## 以太坊账户（两种）：

| 外部账户 EOA   | 合约账户 CA |
| -------- | ----------- |
| 由私钥控制<br>私钥不可更改 | 由智能合约的 **代码** 控制 <br>在智能合约创建后自动运行 |
|地址是40位十六进制数<br>地址通过私钥–>公钥–>公钥SHA3–>取前20个字节的16进制字符|地址是40位十六进制数<br>hex(Hash(from_addr, nonce)[0:20])<br>[1]|
|无代码|有代码|
|有账户余额|有账户余额|
| 能触发交易<br>转账或执行智能合约 | 不能主动发起交易<br>能被触发执行智能合约代码 |

[1] 地址根据发起方（EOA）地址及其当前nonce进行Hash运算(Keccak256)取前20个字节的16进制字符  
[online Keccak256 calculator](https://emn178.github.io/online-tools/keccak_256.html)  
SHA-3 (Keccak256)  
SHA-3 (Secure Hash Algorithm 3) is the latest member of the Secure Hash Algorithm family of standards, released by NIST on August 5, 2015. Although part of the same series of standards, SHA-3 is internally different from the MD5-like structure of SHA-1 and SHA-2.

智能合约账户的地址格式和普通账户是一样的， 只根据地址是区分不出它是智能合约还是普通账户地址。 但是智能合约的地址是没有私钥的，地址格式一样，只能根据账户地址去节点中查询才能知道代表的是何种账户类型。 
[reference](https://wupeaking.github.io/learn/smartcode/)

1. 外部账户（externally owned accounts），由私钥控制；可以触发交易
2. 合约账户（contract accounts），由智能合约的代码控制，智能合约代码 **不可修改**；不能主动发起交易，只能在被触发后按预先编写的智能合约代码执行 

[reference](https://eth.tokenview.com/cn/learn/eth-address)  
[reference](http://c.biancheng.net/view/1935.html)  
[图](http://c.biancheng.net/uploads/allimg/190109/1-1Z109152642922.gif)

### 以太坊的账户包括四个字段：
1. 随机数 nonce: nonce 值代表当前账户执行交易的次数
2. 账户的余额
3. 合约代码（只有CA有，存储的是 codeHash 这个账户的以太坊虚拟机代码的哈希值）
4. 存储（通常为空）

## 外部账户和合约账户的区别
1. 外部账户(EOA)

该类账户被公钥-私钥对控制（人类）。以太坊地址代表一个帐户。对于外部账户，地址是作为控制该账户的公钥的最后20个字节导出的，一个字节8bits， 可存2位十六进制数，所以一个地址40位十六进制数. 

例如：0x71C7656EC7ab88b098defB751B7401B5f6d8976F。这是一个十六进制格式（基数为16的表示法），通常通过向地址附加0x来明确指出。

外部账户的地址是由公钥加密后生成的，所以用户需要谨慎对待私钥，私钥用来查看和处理我们账户中的资产，一旦丢失，资产将永远丢失。

2. 合约账户（CA）  
合约账户可以设置多重签名（multisign），比如一个简单示例是：现有一个合约账户，它要求一个转账由发起转账的人（Alice）和另一个人（Charles）签名才能生效。因此，当 Alice 通过这个合约向 Bob 转账 20 个 ETH 时，合约会通知 Charles 签名，在他签名后，Bob 才可以收到这 20 个 ETH（见图2）。  
[图2](http://c.biancheng.net/uploads/allimg/190109/1-1Z109153151442.gif)  
![图2](http://c.biancheng.net/uploads/allimg/190109/1-1Z109153151442.gif)

## 以太坊的交易
以太坊的交易是状态转换函数，一个交易触发它的执行，它将相应的账户从一个状态转变成新状态，然后新状态被存储在区块链的数据区块中。
