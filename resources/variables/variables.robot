*** Variables ***
 # Authentication variables
${BASE_URL}    https://restful-booker.herokuapp.com
${AUTH_ENDPOINT}    /auth
${USERNAME}    admin
${PASSWORD}    password123
${TOKEN}    None
${SESSION_NAME}  booking
# Performance Metrics
${RESPONSE_TIME_FAST}          500      # milliseconds
${RESPONSE_TIME_NORMAL}        1000     # milliseconds
${RESPONSE_TIME_SLOW}          2000     # milliseconds
${RESPONSE_TIME_TIMEOUT}       5000     # milliseconds

# HTTP Status Codes
${HTTP_OK}                     200
${HTTP_CREATED}                201
${HTTP_ACCEPTED}               202
${HTTP_NO_CONTENT}             204
${HTTP_BAD_REQUEST}            400
${HTTP_UNAUTHORIZED}           401
${HTTP_FORBIDDEN}              403
${HTTP_NOT_FOUND}              404
${HTTP_METHOD_NOT_ALLOWED}     405
${HTTP_CONFLICT}               409
${HTTP_INTERNAL_SERVER_ERROR}  500
${HTTP_SERVICE_UNAVAILABLE}    503

# Inalid Test Data
${INVALID_FIRSTNAME}  InvalidName
${INVALID_DATE}   2023/01/01
# Valid Test Data
${VALID_FIRSTNAME}    James
${VALID_LASTNAME}     Brown
${VALID_PRICE}        111
${VALID_DEPOSIT}      true
${VALID_NEEDS}        Breakfast
${VALID_CHECKIN_DATE}   2018-01-01
${VALID_CHECKOUT_DATE}   2019-01-01
# Partial Update Test Data
${UPDATE_FIRSTNAME}    firstname=UpdatedFirstName
${UPDATE_LASTNAME}     lastname=UpdatedLastName
${UPDATE_PRICE}        totalprice=999
${UPDATE_DEPOSIT}      depositpaid=false
${UPDATE_NEEDS}        additionalneeds=Updated needs
${UPDATE_DATES}
...    bookingdates_checkin=2023-12-01
...    bookingdates_checkout=2023-12-05
${MULTIPLE_FIELD_UPDATE}
...    firstname=MultiUpdate
...    lastname=Test
...    totalprice=555

&{BOOKING_DATES}
...    checkin=2023-02-15
...    checkout=2023-02-20

&{VALID_BOOKING}
...    firstname=Sarah
...    lastname=Smith
...    totalprice=250
...    depositpaid=false
...    additionalneeds=Late checkout

# Partial Update Test Data
&{PARTIAL_UPDATE_FIRSTNAME}    firstname=UpdatedFirstName
&{PARTIAL_UPDATE_LASTNAME}     lastname=UpdatedLastName
&{PARTIAL_UPDATE_PRICE}        totalprice=999
&{PARTIAL_UPDATE_DEPOSIT}      depositpaid=false
&{PARTIAL_UPDATE_NEEDS}        additionalneeds=Updated needs

&{PARTIAL_UPDATE_DATES}
...    bookingdates_checkin=2023-12-01
...    bookingdates_checkout=2023-12-05

&{MULTIPLE_FIELD_UPDATE_FIRSTNAME}      firstname=MultiUpdate
&{MULTIPLE_FIELD_UPDATE_LASTNAME}    lastname=Test
&{MULTIPLE_FIELD_UPDATE_PRICE}   totalprice=555


# Invalid Test Data for Negative Testing
&{INVALID_BOOKING_MISSING_FIRSTNAME}
...    lastname=Test
...    totalprice=100
...    depositpaid=true

&{INVALID_BOOKING_MISSING_LASTNAME}
...    firstname=Test
...    totalprice=100
...    depositpaid=true

&{INVALID_BOOKING_NEGATIVE_PRICE}
...    firstname=Test
...    lastname=User
...    totalprice=-50
...    depositpaid=true

&{INVALID_BOOKING_STRING_PRICE}
...    firstname=Test
...    lastname=User
...    totalprice=invalid_price
...    depositpaid=true

&{INVALID_BOOKING_INVALID_DEPOSIT}
...    firstname=Test
...    lastname=User
...    totalprice=100
...    depositpaid=maybe