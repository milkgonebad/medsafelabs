Feature:  An Admin can CRUD Tests for a customer

	As an admin
	In order to record the results of a test
	I should be able to CRUD tests on behave of a user
	

Background:
	Given I am an admin with email "some_admin@medsafelabs.com"
	And customer "Bob Small" exists

Scenario:  An admin can view a customer's tests
	Given I am on the customer index page
	When I follow the tests link next to "Bob"
	Then I should see a page to create tests for "Bob"

Scenario:  An admin can create a test for a customer
	Given I am on customer "Bob" test page
	When I follow the New Test link
	And I fill in the form
	Then I should be on Bob's test page
	And his test should appear
	
Scenario:  View tests associated with an order



QR code stickers:

We encode each QR code with a url that is basically a link to the site plus a number or unique string.

Admin hands out stickers:
1.  Admin logs into the site
2.  Admin Creates/finds the customer and takes an order.  This info is stored in session.
3.  Admin uses the laptop camera and QR reading software to scan the code.
4.  The app provides a link to the site with the qr code in the url.
5.  Admin clicks the link.
6.  The app looks up the QR code and doesn't recognize it.
7.  Since the admin is already logged in and has a customer in session, the app asks the admin if they would like to create a new test for this qr code.
8.  Admin clicks yes and the qr code is saved to the db.
This is where we'll need to add something to scan multiple qr codes quickly and save them.

If there is no order in session, the app will ask if you want to create a new test and offer a way to search for customers/create an order.

If the admin is not logged in, the admin will be prompted to login, then they will be given the search for customer, create order, create new test path.

Admin scans a sample's qr code.
1.  Admin logs in
2.  Admin uses the computer's scanning app to scan a code.
3.  The app presents the same url to the admin.
4.  The admin clicks it and is brought to the site.
5.  The site recognizes the code and brings up the test page.
6.  ...