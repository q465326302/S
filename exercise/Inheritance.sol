pragma solidity ^0.8.4;
contract Yeye {
    event Log(string mag);
    function hip() public virtual {
        emit Log("Yeye");
    }
    function pop() public virtual {
        emit Log("Yeye");
    }
    function yeye() public virtual {
        emit Log("Yeye");
    }
}
contract Baba is Yeye{
    function hip() public virtual override {
        emit Log("Baba");
    }
    function pop() public virtual override {
        emit Log("Baba");
    }
    function baba() public virtual {
        emit Log("Baba");
    }
}
contract Erzi is Yeye,Baba {
    function hip() public virtual override(Yeye,Baba) {
        emit Log("Erzi");
    }
    function pop() public virtual override(Yeye,Baba) {
        emit Log("Erzi");
    }
}
contract Base1 {
    modifier exactDividedBy2And3(uint _a) virtual {
        require(_a % 2 == 0 && _a % 3 == 0);
        _;
    }
    function getExactDividedBy2And3(uint _dividend) public exactDividedBy2And3(_dividend) pure returns(uint,uint) {
        return getExactDividedBy2And3WithoutModifer(_dividend);
    }
    function getExactDividedBy2And3WithoutModifer(uint _dividend) public pure returns(uint,uint) {
        uint div2 = _dividend / 2;
        uint div3 = _dividend / 3;
        return(div2,div3);
    }

}