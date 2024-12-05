// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

/// @title ERC20 Token Implementation for Learning
/// @author b13kjack
/// @notice This contract implements the ERC-20 standard, allowing for basic token operations.
/// @dev This contract follows the ERC-20 standard as defined in https://eips.ethereum.org/EIPS/eip-20
contract ERC20 {
    // Token details
    string public ExampleToken;         // Name of the token (e.g., "MyToken")
    string public EXMP;                // Symbol of the token (e.g., "MTK")
    uint8 public decimals = 18;       // Number of decimal places (commonly 18)
    uint256 public totalSupply;      // Total number of tokens in circulation

    // Mappings to keep track of balances and allowances
    mapping(address => uint256) private balances; // Stores the balance of each address
    mapping(address => mapping(address => uint256)) private allowances; // Stores allowances

    // Events as per the ERC-20 standard
    event Transfer(address indexed from, address indexed to, uint256 value); // Triggered on transfers
    event Approval(address indexed owner, address indexed spender, uint256 value); // Triggered on approvals

    /**
     * @dev Constructor initializes the token with a name, symbol, decimals, and initial supply.
     * @param _name The name of the token.
     * @param _symbol The symbol of the token.
     * @param _decimals The number of decimal places the token uses.
     * @param _initialSupply The initial number of tokens created.
     */
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _initialSupply
    ) {
        ExampleToken = _name;                         // Set the token name
        EXMP = _symbol;                    // Set the token symbol
        decimals = _decimals;               // Set the number of decimals
        _mint(msg.sender, _initialSupply); // Mint the initial supply to the deployer
        // msg.sender refers to the address that deployed the contract
    }

    /**
     * @dev Internal function to create new tokens and assign them to an account.
     * @param account The address receiving the minted tokens.
     * @param amount The number of tokens to mint.
     */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address"); // Prevent minting to the zero address

        totalSupply += amount;                          // Increase the total supply
        balances[account] += amount;                  // Add the minted tokens to the recipient's balance

        emit Transfer(address(0), account, amount); // Emit a Transfer event from the zero address to indicate minting
    }

    /**
     * @dev Returns the balance of a specific address.
     * @param account The address to query.
     * @return The number of tokens owned by the specified address.
     */
    function balanceOf(address account) public view returns (uint256) {
        return balances[account];   // Retrieve the balance from the mapping
    }

    /**
     * @dev Transfers tokens from the caller's account to another account.
     * @param to The recipient's address.
     * @param amount The number of tokens to transfer.
     * @return A boolean indicating whether the operation succeeded.
     */
    function transfer(address to, uint256 amount) public returns (bool) {
        require(to != address(0), "ERC20: transfer to the zero address");                   // Ensure the recipient is valid
        require(amount <= balances[msg.sender], "ERC20: transfer amount exceeds balance"); // Ensure the sender has enough balance

        balances[msg.sender] -= amount;           // Subtract the amount from the sender's balance
        balances[to] += amount;                 // Add the amount to the recipient's balance

        emit Transfer(msg.sender, to, amount); // Emit a Transfer event

        return true;                           // Indicate success
    }

    /**
     * @dev Approves a spender to transfer tokens on behalf of the caller.
     * @param spender The address authorized to spend.
     * @param amount The maximum amount they can spend.
     * @return A boolean indicating whether the operation succeeded.
     */
    function approve(address spender, uint256 amount) public returns (bool) {
        require(spender != address(0), "ERC20: approve to the zero address"); // Ensure the spender is valid

        allowances[msg.sender][spender] = amount;     // Set the allowance

        emit Approval(msg.sender, spender, amount); // Emit an Approval event

        return true;                                // Indicate success
    }

    /**
     * @dev Returns the remaining number of tokens that a spender is allowed to spend on behalf of an owner.
     * @param owner The address which owns the funds.
     * @param spender The address authorized to spend.
     * @return The remaining allowance for the spender.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return allowances[owner][spender]; // Retrieve the allowance from the mapping
    }

    /**
     * @dev Transfers tokens from one address to another using an allowance.
     * @param from The address to send tokens from.
     * @param to The address to receive tokens.
     * @param amount The number of tokens to transfer.
     * @return A boolean indicating whether the operation succeeded.
     */
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(from != address(0), "ERC20: transfer from the zero address"); // Ensure the sender is valid
        require(to != address(0), "ERC20: transfer to the zero address"); // Ensure the recipient is valid
        require(amount <= balances[from], "ERC20: transfer amount exceeds balance"); // Ensure the sender has enough balance
        require(amount <= allowances[from][msg.sender], "ERC20: transfer amount exceeds allowance"); // Ensure the caller is allowed to spend

        balances[from] -= amount;                        // Subtract the amount from the sender's balance
        balances[to] += amount;                         // Add the amount to the recipient's balance
        allowances[from][msg.sender] -= amount;        // Decrease the allowance

        emit Transfer(from, to, amount);            // Emit a Transfer event

        return true;                                 // Indicate success
    }
}
