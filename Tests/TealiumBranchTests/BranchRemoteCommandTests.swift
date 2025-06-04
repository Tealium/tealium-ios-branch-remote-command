//
//  BranchRemoteCommandTests.swift
//  TealiumBranchTests
//
//  Created by Tyler Rister on 10/20/21.
//

import XCTest
@testable import TealiumBranch
import TealiumRemoteCommands

class BranchRemoteCommandTests: XCTestCase {

    let branchInstance = MockBranchInstance()
    var branchCommand: BranchRemoteCommand!

    override func setUp() {
        branchCommand = BranchRemoteCommand(branchInstance: branchInstance)
    }

    override func tearDown() {
    }
 
    // MARK: - Basic Commands Tests
    
    func testInitialize() {
        let payload: [String: Any] = ["command_name": "initialize"]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.initializeCount)
    }
    
    func testSetIdentity() {
        let payload: [String: Any] = [
            "command_name": "setidentity", 
            "user_id": "testUserId"
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.setIdentityCount)
        XCTAssertEqual("testUserId", branchInstance.lastUserId)
    }
    
    func testSetIdentityMissingUserId() {
        let payload: [String: Any] = ["command_name": "setidentity"]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, branchInstance.setIdentityCount)
    }
    
    func testLogout() {
        let payload: [String: Any] = ["command_name": "logout"]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.logoutCount)
    }
    
    func testClearUserIdentity() {
        let payload: [String: Any] = ["command_name": "clearuseridentity"]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.clearUserIdentityCount)
    }
    
    // MARK: - Deep Link Tests
    
    func testHandleDeepLink() {
        let payload: [String: Any] = [
            "command_name": "handledeeplink",
            "deep_link_url": "https://example.com/deeplink"
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.handleDeepLinkCount)
        XCTAssertEqual("https://example.com/deeplink", branchInstance.lastDeepLinkURL)
    }
    
    // MARK: - Event Tests
    
    func testStandardEventWithBuoData() {
        let buoData: [String: Any] = [
            "canonical_identifier": "testIdentifier",
            "canonical_url": "testUrl",
            "title": "testTitle",
            "content_description": "testDescription",
            "image_url": "testImageUrl"
        ]
        let payload: [String: Any] = ["command_name": "addtocart", "buo": buoData]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.sendEventCount)
    }
    
    func testCustomEvent() {
        let payload: [String: Any] = ["command_name": "custom_event_name"]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.sendCustomEventCount)
    }
    
    // MARK: - Content Indexing Tests
    
    func testListOnSpotlight() {
        let buoData: [String: Any] = ["title": "Test Content"]
        let payload: [String: Any] = [
            "command_name": "listonspotlight",
            "buo": buoData
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.listOnSpotlightCount)
    }
    
    func testRemoveFromSpotlight() {
        let buoData: [String: Any] = ["title": "Test Content"]
        let payload: [String: Any] = [
            "command_name": "removefromspotlight",
            "buo": buoData
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.removeFromSpotlightCount)
    }
    
    // MARK: - ATT and Metadata Tests
    
    func testHandleATTAuthorizationStatus() {
        let payload: [String: Any] = [
            "command_name": "handleattauthorizationstatus",
            "att_status": 3
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.handleATTAuthorizationStatusCount)
    }
    
    func testSetRequestMetadataKey() {
        let payload: [String: Any] = [
            "command_name": "setrequestmetadatakey",
            "metadata_key": "test_key",
            "metadata_value": "test_value"
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.setRequestMetadataKeyCount)
        XCTAssertEqual("test_key", branchInstance.lastMetadataKey)
        XCTAssertEqual("test_value", branchInstance.lastMetadataValue)
    }
    
    // MARK: - Consumer Protection Tests
    
    func testSetConsumerProtectionAttributionLevel() {
        let payload: [String: Any] = [
            "command_name": "setconsumerprotectionattributionlevel",
            "consumer_protection_level": "reduced"
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.setConsumerProtectionAttributionLevelCount)
        XCTAssertEqual("reduced", branchInstance.lastConsumerProtectionLevel)
    }
    
    // MARK: - Network Configuration Tests
    
    func testSetCustomServerURL() {
        let payload: [String: Any] = [
            "command_name": "setcustomserverurl",
            "custom_server_url": "https://custom.branch.io"
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.setCustomServerURLCount)
        XCTAssertEqual("https://custom.branch.io", branchInstance.lastCustomServerURL)
    }
    
    func testSetSafetrackAPIURL() {
        let payload: [String: Any] = [
            "command_name": "setsafetrackapi",
            "safetrack_api_url": "https://safetrack.branch.io"
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.setSafetrackAPIURLCount)
    }
    
    func testUseEUEndpoints() {
        let payload: [String: Any] = ["command_name": "useeuendpoints"]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.useEUEndpointsCount)
    }
    
    func testSetNetworkTimeout() {
        let payload: [String: Any] = [
            "command_name": "setnetworktimeout",
            "network_timeout": 30.0
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.setNetworkTimeoutCount)
        XCTAssertEqual(30.0, branchInstance.lastNetworkTimeout)
    }
    
    func testSetMaxRetries() {
        let payload: [String: Any] = [
            "command_name": "setmaxretries",
            "max_retries": 5
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.setMaxRetriesCount)
        XCTAssertEqual(5, branchInstance.lastMaxRetries)
    }
    
    func testSetRetryInterval() {
        let payload: [String: Any] = [
            "command_name": "setretryinterval",
            "retry_interval": 2.5
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.setRetryIntervalCount)
    }
    
    // MARK: - Partner Parameters Tests
    
    func testAddFacebookPartnerParameter() {
        let payload: [String: Any] = [
            "command_name": "addfacebookpartnerparameter",
            "parameter_name": "fb_param",
            "parameter_value": "fb_value"
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.addFacebookPartnerParameterCount)
    }
    
    func testAddSnapPartnerParameter() {
        let payload: [String: Any] = [
            "command_name": "addsnappartnerparameter",
            "parameter_name": "snap_param",
            "parameter_value": "snap_value"
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.addSnapPartnerParameterCount)
    }
    
    func testClearPartnerParameters() {
        let payload: [String: Any] = ["command_name": "clearpartnerparameters"]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.clearPartnerParametersCount)
    }
    
    // MARK: - DMA Compliance Tests
    
    func testSetDMACompliance() {
        let payload: [String: Any] = [
            "command_name": "setdmacompliance",
            "dma_eea_region": true,
            "dma_ad_personalization_consent": false,
            "dma_ad_user_data_usage_consent": true
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.setDMAComplianceCount)
    }
    
    func testEnableLoggingAtLevel() {
        let payload: [String: Any] = [
            "command_name": "enableloggingatlevel",
            "log_level": "debug"
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.enableLoggingAtLevelCount)
    }
    
    // MARK: - ODM Info Tests
    
    func testSetODMInfo() {
        let payload: [String: Any] = [
            "command_name": "setodminfo",
            "odm_info": "test_odm_info",
            "first_open_timestamp": 1640995200000.0
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.setODMInfoCount)
    }
    
    // MARK: - Additional Configuration Tests
    
    func testDisableAdNetworkCallouts() {
        let payload: [String: Any] = [
            "command_name": "disableadnetworkcallouts",
            "disable_ad_network_callouts": true
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.disableAdNetworkCalloutsCount)
    }
    
    func testResetUserSession() {
        let payload: [String: Any] = ["command_name": "resetusersession"]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.resetUserSessionCount)
    }
    
    func testValidateSDKIntegration() {
        let payload: [String: Any] = ["command_name": "validatesdkintegration"]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.validateSDKIntegrationCount)
    }
    
    func testSetDeepLinkDebugMode() {
        let payload: [String: Any] = [
            "command_name": "setdeeplinkdebugmode",
            "debug_params": ["param1": "value1", "param2": "value2"]
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.setDeepLinkDebugModeCount)
    }
    
    func testSetAllowedSchemes() {
        let payload: [String: Any] = [
            "command_name": "setallowedschemes",
            "allowed_schemes": ["https", "myapp", "custom"]
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.setAllowedSchemesCount)
    }
    
    func testAddAllowedScheme() {
        let payload: [String: Any] = [
            "command_name": "addallowedscheme",
            "scheme": "myapp"
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.addAllowedSchemeCount)
    }
    
    func testSetUrlPatternsToIgnore() {
        let payload: [String: Any] = [
            "command_name": "seturlpatternstoignore",
            "url_patterns": ["*.facebook.com", "*.google.com"]
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.setUrlPatternsToIgnoreCount)
    }
    
    func testSetAppClipAppGroup() {
        let payload: [String: Any] = [
            "command_name": "setappclipappgroup",
            "app_group": "group.com.example.app"
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.setAppClipAppGroupCount)
    }
    
    func testRegisterPluginName() {
        let payload: [String: Any] = [
            "command_name": "registerpluginname",
            "plugin_name": "TealiumBranch",
            "plugin_version": "2.0.0"
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.registerPluginNameCount)
    }
    
    func testSetReferrerGbraidValidityWindow() {
        let payload: [String: Any] = [
            "command_name": "setreferrergbraidvaliditywindow",
            "gbraid_validity_window": 86400.0
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.setReferrerGbraidValidityWindowCount)
    }
    
    // MARK: - Multiple Commands Test
    
    func testMultipleCommands() {
        let payload: [String: Any] = [
            "command_name": "initialize,logout,resetusersession",
            "user_id": "testUser"
        ]
        branchCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, branchInstance.initializeCount)
        XCTAssertEqual(1, branchInstance.logoutCount)
        XCTAssertEqual(1, branchInstance.resetUserSessionCount)
    }
    
    // MARK: - Debug Mode Test
    
    func testDebugModeEnabled() {
        let payload: [String: Any] = [
            "command_name": "setidentity",
            "debug": true
        ]
        branchCommand.processRemoteCommand(with: payload)
        // Should not call setIdentity because user_id is missing, but debug mode should be enabled
        XCTAssertEqual(0, branchInstance.setIdentityCount)
        XCTAssertTrue(branchCommand.debug)
    }
    
    // MARK: - Error Cases Tests
    
    func testMissingCommandName() {
        let payload: [String: Any] = ["user_id": "testUser"]
        branchCommand.processRemoteCommand(with: payload)
        // No commands should be executed
        XCTAssertEqual(0, branchInstance.initializeCount)
        XCTAssertEqual(0, branchInstance.setIdentityCount)
    }
}
