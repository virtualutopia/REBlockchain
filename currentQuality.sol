pragma solidity >0.6.0;
// "SPDX-License-Identifier: UNLICENSED"
contract Quality 
{
    enum TEST_STATE { REJECT, PASS }
    //enum PERMIT { TRUE, FALSE }
    //enum CERTIFICATE { TRUE, FALSE }
    
    // these three tests are requireed for each elevator 
    struct ElevatorQualityReport {
        uint serialnumberOfElevator;
        TEST_STATE doorTest;
        TEST_STATE cableTest;
        TEST_STATE brakeTest;
    }
    struct ColumnQulaityReport{
        uint serialnumberOfColumn;
        TEST_STATE columnCertificate;
    }
    // Each package of battery-columns-elevators is considered in a QualityTerm
    struct QualityPackage{
        address QCID;
        // "data" is all the inromfation received from previous block
        uint256 data;
        TEST_STATE doorTest;
        TEST_STATE cableTest;
        TEST_STATE brakeTest;
        // ColumnQulaityReport [] columnQualityReport;
        // ElevatorQualityReport [] elevatorQualityReport;
        TEST_STATE batteryPermit;
        // bytes32 columnCertificate; 
    }
       //state variables
    uint256 data;
    address owner;
    address QCID;
    uint numberOfCulomn;
    uint numberofElevatorPerColumn;
    address toShipping;
    address fromSolutionManufacturing;
    
    function firstFunction(
        uint256 initData,
        address initOwner
        // uint _numberOfCulomn,
        // uint _numberofElevatorPerColumn
    ) external
    {
        data = initData;
        owner = initOwner;
        // QCID = msg.sender;
        // numberOfCulomn = _numberOfCulomn;
        // numberofElevatorPerColumn = _numberofElevatorPerColumn;
    }
    
   
    // mapping(uint => QualityPackage) QualityPackages;
    mapping (address => QualityPackage) QualityPackages;
    
    
    function testDoor (address _QCID) public {
        
        QualityPackages[_QCID].doorTest = TEST_STATE.PASS;
    }
    function testCable (address _QCID) public {
        
        QualityPackages[_QCID].cableTest = TEST_STATE.PASS;
    }
    function testBrake (address _QCID) public {
        
        QualityPackages[_QCID].brakeTest = TEST_STATE.PASS;
    }    
    
    
    function certification(address _QCID) public  returns(string memory){
        // bytes32 QCID_hash = concatenateInfoAndHash(msg.sender, data, serialnumber);
        require(QualityPackages[_QCID].QCID == address(0), 'A certificate for this QC ID is already issued'); 
        
        // Qualities[QCID_hash].doorTest = testDoor(QCID_hash);
        // Qualities[QCID_hash].cableTest = testCable(QCID_hash);
        // Qualities[QCID_hash].brakeTest = testBrake(QCID_hash);
        // Qualities[QCID_hash].batteryPermit = permitBattery(QCID_hash);
        
        // TEST_STATE doorTestResult = testDoor(QCID_hash);
        require(QualityPackages[_QCID].doorTest == TEST_STATE.PASS, "Door test failed");
        require(QualityPackages[_QCID].cableTest == TEST_STATE.PASS, "Cable test failed");
        require(QualityPackages[_QCID].brakeTest == TEST_STATE.PASS, "Brake test failed");
        // require(QualityPackages[serialnumber].doorTest == TEST_STATE.PASS, "Door test failed");
        // require(QualityPackages[serialnumber].cableTest == TEST_STATE.PASS, "Cable test failed");
        // require(Qualities[QCID_hash].brakeTest == TEST_STATE.PASS, "Brake test failed");
        // require(Qualities[QCID_hash].batteryPermit == TEST_STATE.PASS, "Battery permit not issued");
        
        QualityPackages[_QCID] = QualityPackage(_QCID, data, QualityPackages[_QCID].doorTest, QualityPackages[_QCID].cableTest, QualityPackages[_QCID].brakeTest, QualityPackages[_QCID].batteryPermit);
        return ("Certification for this column is issued");
    }
    
    // convert uint to string funciton
    // function uintToString(uint v) internal  returns (string memory str) {
    //     uint maxlength = 100;
    //     bytes memory reversed = new bytes(maxlength);
    //     uint i = 0;
    //     while (v != 0) {
    //         uint remainder = v % 10;
    //         v = v / 10;
    //         reversed[i++] = byte(48 + remainder);
    //     }
    //     bytes memory s = new bytes(i + 1);
    //     for (uint j = 0; j <= i; j++) {
    //         s[j] = reversed[i - j];
    //     }
    //     str = string(s);
    // }
    
    function toBytes(uint256 x) internal pure returns (bytes  memory b) {
    b = new bytes(32);
    assembly { mstore(add(b, 32), x) }
    }
    
    function concatenateInfoAndHash(
        address a1, 
        uint256  s1,
        uint s2
        // string memory s2, 
        // string memory s3, 
        // string memory s4
    ) internal pure returns (bytes32){
        //First, get all values as bytes
        bytes20 b_a1 = bytes20(a1);
        bytes memory b_s1 = toBytes(s1);
        bytes memory b_s2 = toBytes(s2);
        // bytes memory b_s2 = bytes(s2);
        // bytes memory b_s3 = bytes(s3);
        // bytes memory b_s4 = bytes(s4);

        //Then calculate and reserve a space for the full string
        string memory s_full = new string(
            b_a1.length + 
            b_s1.length +
            b_s2.length
            // + b_s3.length + b_s4.length
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
        // for(i = 0; i < b_s2.length; i++){
        //     b_full[j++] = b_s2[i];
        // }
        // for(i = 0; i < b_s3.length; i++){
        //     b_full[j++] = b_s3[i];
        // }
        // for(i = 0; i < b_s4.length; i++){
        //     b_full[j++] = b_s4[i];
        // }

        //Hash the result and return
        return keccak256(b_full);
    }
}