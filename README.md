# Automation UI test for Restful-bookerAPI using Robot Framework

## Overview

This project contains comprehensive automated tests for the Restful-booker API using Robot Framework. The test suite covers GET, PATCH, and DELETE endpoints with complete validation, error handling, and performance testing.

## Project Structure

```
Restful-bookerAPI/
├── tests/
│   ├── booking/
│   │   ├── get_booking_tests.robot
│   │   ├── update_booking_tests.robot
│   │   └── delete_booking_tests.robot
│   └── integration/
│       └── bookingE2E.robot
├── resources/
│   ├── keywords/
│   │   ├── authentication_keywords.robot
│   │   ├── delete_booking_keywords.robot
│   │   └── get_booking_keywords.robot
│   │   └── update_booking_keywords.robot
│   │
│   ├── variables/
│   │   ├── variables.robot
│   │  
│   ├── data/
│   │   ├── neagtivr_data.json
│   │   ├── valid_data.csv
│   
├── reports/
├── .github/
│   └── workflows/
│       └── robot-framework.yml
└── README.md
```

## Prerequisites
Before running the tests, ensure that you have the following software and tools installed on your machine:

- Python (version 3.14) or higher
- Robot Framework (install using `pip install robotframework`)
- RequestsLibrary (for API testing, install using `pip install robotframework-requests`)

## Installation Instructions
1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd Restful-bookerAPI
2. Install the required packages:
   ```bash
   pip install -r requirements.txt

## How to Run Tests
To execute the tests, navigate to the project's root directory and run the following command:

   # Run API tests and generate reports 
        robot --outputdir reports tests/

## Test Coverage

### GET /booking Tests
- ✅ Retrieve all booking IDs
- ✅ Filter by firstname
- ✅ Filter by lastname  
- ✅ Filter by checkin date
- ✅ Filter by checkout date
- ✅ Multiple filter combinations
- ✅ Invalid date format handling
- ✅ Performance validation (< 2s)
- ✅Validate Booking Response Structure

### PATCH /booking/{id} Tests
- ✅ Update single fields
- ✅ Update multiple fields
- ✅ Update nested objects (bookingdates)
- ✅ Verify unchanged fields remain intact
- ✅ Invalid booking ID handling (404)
- ✅ Invalid data type handling
- ✅ Idempotency verification

### DELETE /booking/{id} Tests
- ✅ Successful deletion
- ✅ Deletion verification (GET returns 404)
- ✅ Non-existent booking ID handling
- ✅ Authentication validation
- ✅ Test concurrent deletion scenarios
- ✅ Verify correct HTTP status codes (201 for success)

## CI/CD Integration

The project includes GitHub Actions workflow for:
- Automated test execution
- Report generation

## Best Practices Implemented

1. **Separation of Concerns**: Test logic, keywords, and data are separated
2. **Reusable Keywords**: Common functionality abstracted into keywords
3. **Error Handling**: Comprehensive negative testing scenarios
5. **Performance Testing**: Response time validation
6. **Authentication Management**: Token generation
7. **Clean Architecture**: Well-organized project structure
8. **Documentation**: Comprehensive inline documentation

## Test Strategy

### Functional Testing
- Happy path scenarios for all endpoints
- Data validation testing

### Non-Functional Testing
- Performance testing (response times)
- Security testing (authentication)

### Negative Testing
- Invalid data handling
- Error response validation

## Reporting

Tests generate comprehensive reports including:
- HTML reports with detailed test execution logs
