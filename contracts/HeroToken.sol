// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

error ExceedsAllowance(uint256 amount);
error FromZeroAddress();
error ToZeroAddress();
error ExceedsBalance(uint256 amount, uint256 senderBalance);

contract HeroToken is IERC20 {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) public _allowances;

    // IERC20의 getter 함수들을 상속받아서 구현하므로 public으로 선언하면 getter 함수가 중복되어서 오류가 발생할 수 있음.
    // 따라서 getter 함수들은 external로 선언하고, 내부에서 사용하는 변수들은 private으로 선언.
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor(string memory getName, string memory getSymbol) {
        _name = getName;
        _symbol = getSymbol;
        _decimals = 18;
        _totalSupply = 100000000e18;
        _balances[msg.sender] = _totalSupply;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() external view virtual returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(
        address account
    ) external view virtual returns (uint256) {
        return _balances[account];
    }

    function transfer(
        address recipient,
        uint amount
    ) public virtual returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    //
    // owner가 spender에게 양도 설정한 토큰의 양을 확인
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256) {
        return _allowances[owner][spender];
    }

    // spender에게 value 만큼의 토큰을 인출할 권리를 부여.
    // 이용시 반드시 Approval 이벤트 함수를 호출해야 함.
    function approve(
        address spender,
        uint amount
    ) external virtual returns (bool) {
        _approve(msg.sender, spender, amount, true);
        return true;
    }

    // spender가 거래 가능하도록 양도 받은 토큰을 전송
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external virtual returns (bool) {
        uint256 currentAllowance = _allowances[sender][recipient];
        if (amount > currentAllowance)
            _approve(sender, recipient, amount - currentAllowance, false);
        _transfer(sender, recipient, amount);
        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        if (sender == address(0)) revert FromZeroAddress();
        if (recipient == address(0)) revert ToZeroAddress();
        uint256 senderBalance = _balances[sender];
        if (amount > senderBalance)
            revert ExceedsBalance(amount, senderBalance);
        unchecked {
            _balances[sender] = senderBalance - amount;
            _balances[recipient] += amount;
        }
        emit Transfer(sender, recipient, amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount,
        bool emitEvent
    ) internal virtual {
        if (owner == address(0)) revert FromZeroAddress();
        if (spender == address(0)) revert ToZeroAddress();
        _allowances[owner][spender] = amount;
        if (emitEvent) emit Approval(owner, spender, amount);
    }
}