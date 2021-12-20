// SPDX-License-Identifier: CC-BY-4.0
pragma solidity >=0.4.22 <0.9.0;

/**
 * @dev Collection of functions related to the address type
 */
library AddressUpgradeable {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 *
 * [CAUTION]
 * ====
 * Avoid leaving a contract uninitialized.
 *
 * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
 * contract, which may impact the proxy. To initialize the implementation contract, you can either invoke the
 * initializer manually, or you can include a constructor to automatically mark it as initialized when it is deployed:
 *
 * [.hljs-theme-light.nopadding]
 * ```
 * /// @custom:oz-upgrades-unsafe-allow constructor
 * constructor() initializer {}
 * ```
 * ====
 */
abstract contract Initializable {
    /**
     * @dev Indicates that the contract has been initialized.
     */
    bool private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Modifier to protect an initializer function from being invoked twice.
     */
    modifier initializer() {
        // If the contract is initializing we ignore whether _initialized is set in order to support multiple
        // inheritance patterns, but we only do this in the context of a constructor, because in other contexts the
        // contract may have been reentered.
        require(_initializing ? _isConstructor() : !_initialized, "Initializable: contract is already initialized");

        bool isTopLevelCall = !_initializing;
        if (isTopLevelCall) {
            _initializing = true;
            _initialized = true;
        }

        _;

        if (isTopLevelCall) {
            _initializing = false;
        }
    }

    /**
     * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
     * {initializer} modifier, directly or indirectly.
     */
    modifier onlyInitializing() {
        require(_initializing, "Initializable: contract is not initializing");
        _;
    }

    function _isConstructor() private view returns (bool) {
        return !AddressUpgradeable.isContract(address(this));
    }
}

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract SocialNetworkToken is IERC20 {
  string public name;
  string public symbol;
  uint256 public _totalSupply;

  mapping(address => uint256) private _balances;
  mapping(address => mapping (address => uint256)) allowed;

  bytes32 constant private ZERO_BYTES = bytes32(0);
  address constant private ZERO_ADDRESS = address(0);


  address public _owner;
  bool private initialized;

  struct Comment {
    address commentor;
    uint256 post_index;
    string  message;
  }

  struct UserMeta {
    string profession;
    string location;
    string dob;
    string interests;
  }

  struct LikesDislikes {
    uint256 post;
    address poster;
    address user;
  }

  mapping (address => uint256) private users;
  mapping (address => string[]) private posts;
  mapping (address => Comment[]) private comments;
  mapping (address => LikesDislikes[]) private likes;
  mapping (address => LikesDislikes[]) private dislikes;
  mapping (address => UserMeta) private user_meta;
  mapping (address => uint256) private balances;

  address[] private _users;


  // advertisers
  mapping (address => uint256) private advertisers;
  address[] private _advertisers;
  mapping (address => string) private advertisements;

  //uint256 public totalSupply = 0;
  mapping(uint256 => address) internal tokens;
  event Mint(address indexed _to, uint256 indexed _tokenId, bytes32 _ipfsHash);

  // initializer is a modifier in the @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol
  //function initialize()
  constructor()
  {
    name = "MyKronee Token";
    symbol = "MYK";
    //require(!initialized, "Contract instance has already been initialized");
    _owner = msg.sender;
    //initialized = true;
    _totalSupply = 0;
  }

  modifier onlyOwner() {
    require(msg.sender == _owner, "access denied for owner");
    _;
  }

  modifier addressValid() {
    require(msg.sender != address(0), "missing address");
    _;
  }

  modifier userNotExist() {
    require(users[msg.sender] == 0, "user exists");
    _;
  }

  modifier isUser(address user) {
    require(users[user] != 0,"user does not exist");
    _;
  }

  modifier notUser(address user) {
    require(users[user] == 0,"user already exists");
    _;
  }

  modifier isAdvertiser() {
    require(advertisers[msg.sender] != 0, "not an advertiser");
    _;
  }

  modifier notAdvertiser() {
    require(advertisers[msg.sender] == 0, "is an advertiser");
    _;
  }

  function getOwner()
    public
    view
    returns (address)
  {
    return _owner;
  }

  function getUserRole()
    public
    view
    isUser(msg.sender)
    returns (string memory)
  {
    if (msg.sender == _owner) {
      return string("owner");
    } else if (users[msg.sender] != 0) {
      return string("user");
    } else if (advertisers[msg.sender] != 0) {
      return string("adveriser");
    }
    return string("unknown");
  }

  function totalSupply()
    public
    view
    returns (uint256)
  {
    return _totalSupply;
  }

  function balanceOf(address account)
    public
    view
    returns (uint256)
  {
    return _balances[account];
  }
  function allowance(address owner, address spender)
    public
    view
    returns (uint256)
  {
    return  (_totalSupply - allowed[owner][spender]);
  }

  function transfer(address recipient, uint256 amount)
    public
    returns (bool)
  {
    require(recipient != ZERO_ADDRESS, "missing recipient address");
    if (balances[msg.sender] >= amount && amount > 0 && balances[recipient] + amount > balances[recipient]) { 
      balances[msg.sender] -= amount;
      balances[recipient] += amount;
      emit Transfer(msg.sender, recipient, amount); // trigger event
      return true;
    } else { 
      return false;
    }
  }
  function approve(address spender, uint256 amount)
    public
    returns (bool)
  {
    require(spender != ZERO_ADDRESS, "missing sender address");
    allowed[msg.sender][spender] = amount;
    emit Approval(msg.sender, spender, amount);
    return true;
  }
  function transferFrom(address sender, address recipient, uint256 amount)
    public
    returns (bool)
  {
    require(sender != ZERO_ADDRESS, "missing sender address");
    require(recipient != ZERO_ADDRESS, "missing recipient address");

    if (balances[sender] >= amount && allowed[sender][msg.sender] >= amount && amount > 0 && balances[recipient] + amount > balances[recipient]) {
      balances[sender] -= amount;
      balances[recipient] += amount;
      emit Transfer(sender, recipient, amount);
      return true;
    } else {
      return false;
    } 
  }


  function addUser()
    public
    payable
    addressValid
    userNotExist
  {
    require(allowance(msg.sender, address(this)) >= 0.001 ether, "registration cost 0.001 ether");
    require(transferFrom(msg.sender, address(this),  0.001 ether));    
    users[msg.sender] = 1;
    _users.push(msg.sender);
  }

  function addPost(string memory message)
    public
    payable
    addressValid
    returns (uint256)
  {
    posts[msg.sender].push(message);
    return posts[msg.sender].length - 1;
  }

  function addComment(address poster, uint index, string memory message)
    public
    payable
    addressValid
    isUser(poster)
    isUser(msg.sender)
  {
    Comment memory comment = Comment(msg.sender, index, message);
    comments[poster].push(comment);
  }

  /**
   * interests is comma dellimited string
   */
  function updateUserMeta(string memory profession, string memory location, string memory dob, string memory interests)
    public
    payable
  {
    UserMeta memory meta = UserMeta(profession, location, dob, interests);
    user_meta[msg.sender] = meta;
  }

  // Add a new advertiser
  function addAdvertiser()
    public
    payable
    addressValid
  {
    advertisers[msg.sender] = 1;
    _advertisers.push(msg.sender);
  }

  function newAdvertisement(string memory message)
    public
    payable
    isAdvertiser
  {
    advertisements[msg.sender] = message;
  }

  function getAdvertisers()
    public
    view
    onlyOwner
    returns (address[] memory)
  {
    return _advertisers;
  }

  function getUsers()
    public
    view
    onlyOwner
    returns (address[] memory)
  {
    return _users;
  }

  /**
   * a post may contain many likes, one -> many
   * one like per user per post
   */
  function setLike(uint256 post, address poster, address user)
    public
    payable
    isUser(user)
    isUser(poster)
  {
    LikesDislikes memory like = LikesDislikes(post, poster, user);
    likes[user].push(like);
  }

  function setDislike(uint256 post, address poster, address user)
    public
    payable
    isUser(user)
    isUser(poster)
  {
    LikesDislikes memory like = LikesDislikes(post, poster, user);
    dislikes[user].push(like);
  }

  function getLikes(address user)
    public
    view
    isUser(user)
    returns (LikesDislikes[] memory)
  {
    return likes[user];
  }

  function getDislikes(address user)
    public
    view
    isUser(user)
    returns (LikesDislikes[] memory)
  {
    return dislikes[user];
  }
}
