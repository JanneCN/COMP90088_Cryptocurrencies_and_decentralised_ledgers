pragma solidity ^0.4.21;
// Problem Context
// This is a scissors hammer cloth game for three players
// xiaomi xiaoming xiaogang are three Designated players (Hard coded)
// The three are competing for the winner
// The source code is from https://wupeaking.github.io/learn/smartcode/
contract Winner {
    // Mapping in Solidity acts like a hash table or dictionary in any other language. 
    // These are used to store the data in the form of key-value pairs, 
    // the key can be any of the built-in data types but reference types are not allowed 
    // the value can be of any type.
    // 映射是一种引用类型，存储键值对。它的定义是：mapping(key => value)
    // 概念上与java中的map，python中的字典类型类似，但在使用上有比较多的限制。
    // ref: https://www.cnblogs.com/flyingeagle/p/10140054.html
    mapping(string=>uint8) _mapActions;
    // 相当于在python里建了一个字典，并且指定了key的类型是string，value的类型是uint8
    mapping(address=>bool) _AllAccounts;
    mapping(address=>uint8) _AccountsActions;
    bool start; 
    uint8  xiaomi;
    uint8  xiaoming;
    uint8  xiaogang;
    
    // 这个是构造函数 在合约第一次创建时执行
    constructor() public {
        // 往刚才新建的“字典”里装东西
        _mapActions["scissors"] = 1;
        _mapActions["hammer"] = 2;
        _mapActions["cloth"] = 3;
        
        _AllAccounts[0x763418009b636593e86256ffa32bef1b0218a1e1] = true;  // xiaomi
        _AllAccounts[0x14723a09acff6d2a60dcdf7aa4aff308fddc160c] = true; // xiaoming
        _AllAccounts[0x583031d1113ad414f02576bd6afabfb302140225] = true; // xiaogang

        uint8  xiaomi   = _AccountsActions[0x763418009b636593e86256ffa32bef1b0218a1e1];
        uint8  xiaoming = _AccountsActions[0x14723a09acff6d2a60dcdf7aa4aff308fddc160c];
        uint8  xiaogang = _AccountsActions[0x583031d1113ad414f02576bd6afabfb302140225];

        xiaomi   = 0;
        xiaoming = 0;
        xiaogang = 0;
        
        // _AccountsActions[0x763418009b636593e86256ffa32bef1b0218a1e1] = 0;
        // _AccountsActions[0x14723a09acff6d2a60dcdf7aa4aff308fddc160c] = 0;
        // _AccountsActions[0x583031d1113ad414f02576bd6afabfb302140225] = 0;
    }
    
    // 设置执行动作  要求只能是scissors hammer cloth 
    // 并且要求只能是上述要求的三个以太坊地址
    function setAction( string action) public  returns (bool) {
        if (_mapActions[action] == 0 ) {
            // TODO 这一行不会执行啊？？？ 有啥用？？？
            return false;
        }
        // The msg.sender is the address that has called or initiated a function or created a transaction. 
        // Now, this address could be of a contract or even a person like you and me.
        // msg.sender (address): sender of the message (current call)
        // msg.sender will be the person who's currently connecting with the contract.
        // Later on, you'll probably deal with contracts connecting with contracts. 
        // In that case, the contract that is creating the call would be the msg.sender.
        // https://stackoverflow.com/questions/48562483/solidity-basics-what-msg-sender-stands-for
        // msg.sender 就是调用此 contract 的人, 
        // 此游戏事先指定了玩家，所以只有当玩家合法 _AllAccounts[...] 为true
        // 当 玩家不属于 xiaomi xiaoming xiaogang 其中任意一个，直接结束游戏
        if (!_AllAccounts[msg.sender]) {
            return false;
        }
        // 如果玩家合法，把玩家的action存到对应的_AccountsActions里
        _AccountsActions[msg.sender] = _mapActions[action];
        return true;
    }
    // 重置游戏 让所有玩家的动作归零
    function reset() public {
        // _AccountsActions[0x763418009b636593e86256ffa32bef1b0218a1e1] = 0;
        // _AccountsActions[0x14723a09acff6d2a60dcdf7aa4aff308fddc160c] = 0;
        // _AccountsActions[0x583031d1113ad414f02576bd6afabfb302140225] = 0;
        xiaomi   = 0;
        xiaoming = 0;
        xiaogang = 0;
    }
    
    // The winner is one of xiaomi xiaoming xiaogang
    function whoIsWinner() public returns (string, bool) {
        if (
            // _AccountsActions[0x763418009b636593e86256ffa32bef1b0218a1e1] == 0 ||
            // _AccountsActions[0x14723a09acff6d2a60dcdf7aa4aff308fddc160c] == 0 ||
            // _AccountsActions[0x583031d1113ad414f02576bd6afabfb302140225] == 0
            xiaomi   == 0 ||
            xiaoming == 0 ||
            xiaogang == 0
            ) {
                // if one of the three didn't bid, reset the game state, end game return false
                reset();
                return ("", false);
            }
        // uint8  xiaomi = _AccountsActions[0x763418009b636593e86256ffa32bef1b0218a1e1];
        // uint8  xiaoming = _AccountsActions[0x14723a09acff6d2a60dcdf7aa4aff308fddc160c];
        // uint8  xiaogang = _AccountsActions[0x583031d1113ad414f02576bd6afabfb302140225];
        
        if (xiaomi != xiaoming && xiaomi != xiaogang && xiaoming != xiaogang) {
            // 三个人出不同 没人赢，要想有人赢，必须两个相同，第三个人出能赢的
            reset();
            return ("", false);
        }

        if (xiaomi == xiaoming) {
        // 如果 小米小明 一样， 小刚赢了他俩，小刚赢
            if (winCheck(xiaogang, xiaomi)) {
                return ("小刚", true);
            }else{
                reset();
                return ("", false);
            }
        }
        if (xiaomi == xiaogang) {
        // 如果 小米小刚 一样， 小明赢了他俩，小明赢
            if (winCheck(xiaoming, xiaomi)) {
                return ("小明", true);
            }else{
                reset();
                return ("", false);
            }
        } 
        if (xiaoming == xiaogang) {
        // 如果 小明小刚 一样， 小米赢了他俩，小米赢
            if (winCheck(xiaomi, xiaoming)) {
                return ("小米", true);
            }else{
                reset();
                return ("", false);
            }
        }
        reset();
        return ("", false);
    }
    // a 和 b， a 赢
    function winCheck(uint8 a, uint8 b ) private returns( bool) {
        if(a == 1 && b==3) {
            return true;
        }else if (a==2 && b==1) {
            return true;
        }else if (a==3 && b==2) {
            return true;
        }
        return false;
    }
    
}
