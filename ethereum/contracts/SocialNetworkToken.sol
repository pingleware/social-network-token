// SPDX-License-Identifier: CC-BY-4.0
pragma solidity >=0.4.22 <0.9.0;

import "../node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract SocialNetworkToken is Initializable {

  bytes32 constant private ZERO_BYTES = bytes32(0);
  address constant private ZERO_ADDRESS = address(0);

  address payable private _owner;
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

  mapping (address => uint256) private users;
  mapping (address => string[]) private posts;
  mapping (address => Comment[]) private comments;
  mapping (address => uint256[]) private likes;
  mapping (address => UserMeta) private user_meta;

  address[] private _users;

  // advertisers
  mapping (address => uint256) private advertisers;
  address[] private _advertisers;
  mapping (address => string) private advertisements;

  // initializer is a modifier in the @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol
  function initialize()
   public payable
   initializer
  {
    require(!initialized, "Contract instance has already been initialized");
    _owner = payable(msg.sender); // this may show as a syntax error, but will pass during compile
    initialized = true;
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

  function addUser()
    public
    payable
    addressValid
    userNotExist
  {
    users[msg.sender] = 1;
    _users.push(msg.sender);
  }

  function addPost(string memory message)
    public
    payable
    addressValid
  {
    posts[msg.sender].push(message);
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
}
