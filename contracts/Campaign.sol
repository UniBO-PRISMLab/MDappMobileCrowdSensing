// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Campaign is Ownable, Initializable {
    bool internal isClosed;
    string internal name;
    int256 internal lat;
    int256 internal lng;
    int256 internal range;
    string internal campaignType;
    address internal addressCrowdSourcer;
    mapping(uint256 => File) public files; // file hashes stored in IPFS
    uint256 internal fileCount = 0; // number of the hashes uploaded

    function getInfo() public view returns(string memory,int256,int256,int256,string memory,address,uint256) {
        return(name,lat,lng,range,campaignType,addressCrowdSourcer,fileCount);
    }

    struct File {
        uint256 fileId;
        string filePath;
        uint256 fileSize;
        string fileType;
        string fileName;
        string status;
        bool validity;
        address payable uploader;
    }

    function closeCampaign() external onlyOwner{
        isClosed = true;
    }

    function initialize(string memory _name,int256 _lat,int256 _lng,int256 _range,string memory _type,address _addressCrowdSourcer) external payable onlyOwner initializer {
        name = _name;
        lat = _lat;
        lng = _lng;
        range = _range;
        campaignType = _type;
        addressCrowdSourcer = _addressCrowdSourcer;
        isClosed = false;
    }

    event FileUploaded(uint256 fileId,string filePath,uint256 fileSize,string fileType,string fileName,address payable uploader);

    function uploadFile(string memory _filePath,uint256 _fileSize,string memory _fileType,string memory _fileName,int256 _fileLat,int256 _fileLng) public {
        require(msg.sender != address(0));
        require(isClosed == false,'The campaign is closed by sourcer');
        require(bytes(_filePath).length > 0);
        require(bytes(_fileType).length > 0);
        require(bytes(_fileName).length > 0);
        require(msg.sender != address(0));
        require(_fileSize > 0);

        require(range <= calculateDistance(_fileLat,_fileLng));

        fileCount++;

        files[fileCount] = File(fileCount,_filePath,_fileSize,_fileType,_fileName,"not checked",false,payable(msg.sender));

        emit FileUploaded(fileCount,_filePath,_fileSize,_fileType,_fileName,payable(msg.sender));
    }

    function getFilePaths() public view returns (string[] memory) {
        string[] memory paths;
        for (uint256 i = 0; i < fileCount; i++) {
            paths[i] = (files[i].filePath);
        }
        return paths;
    }

    function sqrt(int256 x) internal pure returns (int256 y) {
        int256 z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
        return y;
    }

    function calculateDistance(int256 latFile, int256 lonFile) internal view returns (int256 dist) {
        int256 distance = sqrt((latFile - lat)**2 + (lonFile - lng)**2);
        return int256(distance);
    }
}
