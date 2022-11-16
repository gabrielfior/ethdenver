// SPDX-License-Identifier: None
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity ^0.8.0;

contract ShameCoin is ERC20, Ownable {
    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol){}

    /** Returns number of decimals for token.
     * @notice  .
     * @dev     .
     * @return  uint8  Number of decimals
     */
    function decimals() public pure virtual override returns (uint8) {
        return 0;
    }

    
    /** Standard ERC20 mint function
     * @param   account  Account to mint to
     * @param   amount  Amount to be minted
     */
    function mint(address account, uint256 amount) public onlyOwner  {
        _mint(account, amount);
    }


    /** Transfer function that, if called by owner, transfers 1 coin to destination. If called by a non-owner, 
     * increases amount of coins of called by 1.
     * @param   to  Transfer recipient
     * @param   amount  Amount to be transferred
     * @return  bool  Whether operation was successful
     */
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        if (msg.sender == owner()){
            require(amount == 1, 'Amount should be equal to 1');
            return super.transfer(to, amount);
        }
        else {
            _mint(msg.sender, 1);
            return true; // To check
        }
    }

    
    /** Approve function where spender must equal the owner and account must equal 1.
     * @param   spender  Spender of tokens
     * @param   amount  Amount of tokens that can be spent by spender in the name of the msg.sender
     * @return  bool  Whether operation was successful
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        require(spender == owner(), 'Spender must be owner');
        require(amount == 1, 'Amount must be 1');
        return super.approve(spender, amount);
    }

     /** Transfer shame coins from one address to the other.
       * @notice  Only reduces balance of msg.sender.
       * @param   from  Address to subtract shame coins from.
       * @param   amount  Amount of coins to transfer
       * @return  bool  Whether operation was successful
       */
      function transferFrom(
        address from,
        address /*to*/,
        uint256 amount
    ) public override returns (bool) {
        // we need transfer A -> B but only remove 1 from A
        // step 1 - transfer from A-> contract
        _burn(from, amount);
        return true;
    }
}