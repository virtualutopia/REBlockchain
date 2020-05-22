pragma solidity >0.6.0;
// "SPDX-License-Identifier: UNLICENSED"
contract Quality 
{

    // Each package of battery-columns-elevators is considered in a QualityTerm
    struct QualityPackage{
        address QCID;
        string doorTest;
        string cableTest;
        string brakeTest;
        string batteryPermit;
        string columnCertificate; 
    }
       //state variables
    uint256 data;
    address owner;
    address QCID;
    uint numberOfCulomn;
    uint numberofElevatorPerColumn;
    address toShipping;
    address fromSolutionManufacturing;
   
    constructor() public {
     owner = msg.sender;
    }
    
    modifier justOwner() {
        // if (msg.sender == owner) _;
        require (msg.sender == owner, 'restricted to owner');
        _;
    }

    // The data from previous blokcs may be input using this function
    function firstFunction(
        uint256 initData

    ) external
    {
        data = initData;
        // owner = initOwner;
    }
    
   
    // mapping(uint => QualityPackage) QualityPackages;
    mapping (address => QualityPackage) QualityPackages;
    
    
    function testDoor (address _QCID) public justOwner{
        QualityPackages[_QCID].doorTest = "PASS";
    }
    function testCable (address _QCID) public justOwner{
        QualityPackages[_QCID].cableTest = "PASS";
    }
    function testBrake (address _QCID) public justOwner{
        QualityPackages[_QCID].brakeTest = "PASS";
    } 
    function permitForBattery (address _QCID) public justOwner{
        QualityPackages[_QCID].batteryPermit = "PERMIT";
    } 
    
    
    function certification(address _QCID) public justOwner  returns(bytes32) {

        require(QualityPackages[_QCID].QCID == address(0), 'A certificate for this QC ID is already issued'); 

        
        require(keccak256(bytes(QualityPackages[_QCID].doorTest)) == keccak256(bytes("PASS")), "Door test failed");
        require(keccak256(bytes(QualityPackages[_QCID].cableTest)) == keccak256(bytes("PASS")), "Cable test failed");
        require(keccak256(bytes(QualityPackages[_QCID].brakeTest)) == keccak256(bytes("PASS")), "Brake test failed");
        require(keccak256(bytes(QualityPackages[_QCID].batteryPermit)) == keccak256(bytes("PERMIT")), "Battry Permit is not yet issued");

        
        QualityPackages[_QCID].columnCertificate = "PASS";
        QualityPackages[_QCID].QCID = msg.sender;
        bytes32 newData_hash = concatenateInfoAndHash (_QCID, data, QualityPackages[_QCID].doorTest, QualityPackages[_QCID].cableTest, QualityPackages[_QCID].brakeTest, QualityPackages[_QCID].batteryPermit, QualityPackages[_QCID].columnCertificate);
        return newData_hash;

    }
    
    
    // converting uint to bytes
    function toBytes(uint256 x) internal pure returns (bytes  memory b) {
    b = new bytes(32);
    assembly { mstore(add(b, 32), x) }
    }
    
    // Concatenating received data and all test results and certificate then converting it to hash.
    function concatenateInfoAndHash(
        address a1, 
        uint256  s1,
        string memory s2, 
        string memory s3, 
        string memory s4,
        string memory s5,
        string memory s6
    ) internal pure returns (bytes32){
        //First, get all values as bytes
        bytes20 b_a1 = bytes20(a1);
        bytes memory b_s1 = toBytes(s1);
        bytes memory b_s2 = bytes(s2);
        bytes memory b_s3 = bytes(s3);
        bytes memory b_s4 = bytes(s4);
        bytes memory b_s5 = bytes(s5);
        bytes memory b_s6 = bytes(s6);
        //Then calculate and reserve a space for the full string
        string memory s_full = new string(
            b_a1.length + 
            b_s1.length +
            b_s2.length +
            b_s3.length +
            b_s4.length +
            b_s5.length +
            b_s6.length 
            );
        bytes memory b_full = bytes(s_full);
        uint j = 0;
        uint i;
        for(i = 0; i < b_a1.length; i++){
            b_full[j++] = b_a1[i];
        }
        for(i = 0; i < b_s1.length; i++){
            b_full[j++] = b_s1[i];
        }
        for(i = 0; i < b_s2.length; i++){
            b_full[j++] = b_s2[i];
        }
        for(i = 0; i < b_s3.length; i++){
            b_full[j++] = b_s3[i];
        }
        for(i = 0; i < b_s4.length; i++){
            b_full[j++] = b_s4[i];
        }
        for(i = 0; i < b_s5.length; i++){
            b_full[j++] = b_s5[i];
        }
        for(i = 0; i < b_s6.length; i++){
            b_full[j++] = b_s6[i];
        }

        //Hash the result and return
        return keccak256(b_full);
    }
}