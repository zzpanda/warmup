"""
Each file that starts with test... in this directory is scanned for subclasses of unittest.TestCase or testLib.RestTestCase
"""

import unittest
import os
import testLib


class TestReset(testLib.RestTestCase):
    """Test adding users"""
    def assertResponse(self, respData, errCode = testLib.RestTestCase.SUCCESS):
        """
        Check that the response data dictionary matches the expected values
        """
        expected = { 'errCode' : errCode }
        self.assertDictEqual(expected, respData)

    def testResetSuccess(self):
        respData = self.makeRequest("/TESTAPI/resetFixture", method="POST", data = {} )
        self.assertResponse(respData)

class TestAddUser(testLib.RestTestCase):
    """Test adding users"""
    def assertResponse(self, respData, count = 1, errCode = testLib.RestTestCase.SUCCESS):
        """
        Check that the response data dictionary matches the expected values
        """
        expected = { 'errCode' : errCode }
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)

    def testAddSucess(self):
        respData = self.makeRequest("/TESTAPI/resetFixture", method="POST", data = {} )
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user1', 'password' : 'password'} )
        self.assertResponse(respData, count = 1)

    def testAddBadUername(self):
        respData = self.makeRequest("/TESTAPI/resetFixture", method="POST", data = {} )
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : '', 'password' : 'password'} )
        self.assertResponse(respData, count = None, errCode = testLib.RestTestCase.ERR_BAD_USERNAME)
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user3'*129, 'password' : 'password'} )
        self.assertResponse(respData, count = None, errCode = testLib.RestTestCase.ERR_BAD_USERNAME)

    def testAddBadPassword(self):
        respData = self.makeRequest("/TESTAPI/resetFixture", method="POST", data = {} )
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user4', 'password' : 'a'*129} )
        self.assertResponse(respData, count = None, errCode = testLib.RestTestCase.ERR_BAD_PASSWORD)

    def testAddUserExists(self):
        respData = self.makeRequest("/TESTAPI/resetFixture", method="POST", data = {} )
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user1', 'password' : 'password'} )
        self.assertResponse(respData, count = 1)
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user1', 'password' : 'password'} )
        self.assertResponse(respData, count = None, errCode = testLib.RestTestCase.ERR_USER_EXISTS )
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user1', 'password' : 'password5'} )
        self.assertResponse(respData, count = None, errCode = testLib.RestTestCase.ERR_USER_EXISTS ) 

    def testAddSamePassword(self):
        respData = self.makeRequest("/TESTAPI/resetFixture", method="POST", data = {} )
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user6', 'password' : 'password'} )
        self.assertResponse(respData, count = 1)

class TestLogin(testLib.RestTestCase):
    """Test adding users"""
    def assertResponse(self, respData, count = 1, errCode = testLib.RestTestCase.SUCCESS):
        """
        Check that the response data dictionary matches the expected values
        """
        expected = { 'errCode' : errCode }
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)

    def testLoginSuccess(self):
        respData = self.makeRequest("/TESTAPI/resetFixture", method="POST", data = {} )
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user1', 'password' : 'password'} )
        self.assertResponse(respData, count = 1)
        respData = self.makeRequest("/users/login", method="POST", data = { 'user' : 'user1', 'password' : 'password'} )
        self.assertResponse(respData, count = 2)
        respData = self.makeRequest("/users/login", method="POST", data = { 'user' : 'user1', 'password' : 'password'} )
        self.assertResponse(respData, count = 3)

    def testLoginWrongPassword(self):
        respData = self.makeRequest("/TESTAPI/resetFixture", method="POST", data = {} )
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user1', 'password' : 'password'} )
        self.assertResponse(respData, count = 1)
        respData = self.makeRequest("/users/login", method="POST", data = { 'user' : 'user1', 'password' : 'password1'} )
        self.assertResponse(respData, count = None, errCode = testLib.RestTestCase.ERR_BAD_CREDENTIALS )

