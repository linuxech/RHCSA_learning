#!/bin/bash

//How to change  password policy?

Criteria
Minimum Days: 5
Maximum Days: 60
Warning: 8

- Go to /etc/login.def
- Go to  line 121 to 133
- Check Values and Update accordingly. 
- Save file. 
Note this will only impact the new user that will be created now.




