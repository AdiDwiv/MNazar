# MNazar

![Alt text](https://cloud.githubusercontent.com/assets/22662617/22573976/e38b12d8-e979-11e6-8052-3d075fb0bd00.jpg)
### General information
* Mnazar is an iOS tracking app for sales employees.  
* Developed by Aditya Dwivedi (ad629@cornell.edu).
* MNazar tracks the location of the user and sends the collected data to a server. This information can be viewed by the employee's superviser. 
* MNazar uses the Google Maps SDK for iOS to display locations.
* MNazar also keeps a record of the total distance travelled by the employee.
* MNazar can be run in the background and does not need to remain open at all times.

### Features
#### 1. Login and auto logout

![Alt text](https://cloud.githubusercontent.com/assets/22662617/22573990/f3dce67a-e979-11e6-8410-836f7993ab03.jpg)
 * Users login using their employee id and password. 
 * They can logout at any given time. The server will stop receiving their location upon logout.
 * The app logs the user out automatically at 7 P.M. local time i.e. at the end of shift.
 * Users cannot login after 7 P.M. or on Sundays.

#### 2. Location tracking

![Alt text](https://cloud.githubusercontent.com/assets/22662617/22573999/0267f4e6-e97a-11e6-8847-5512b8f416a4.jpg)
 * The app begins tracking location immediately after login.
 * It updates location if
  * An hour has passed since location was last updated.
  * The employee moves by a distance greater than 100 metres.
 * An employee can view his own locations listed in a table.
 * Cells are ordered vertically from latest to oldest.
 * Cells display the time the location was first logged and the distance travelled by the employee at that time.
 * Each cell in the table contains a color coded marker indicating how long an employee stayed at that location. THe colors are coded as follows
  * Green: Less than 1 hour
  * Yellow: 1-3 hours
  * Red: More than 3 hours
 * The app toggles between location accuracies to optimize battery usage.
 
#### 3. Map view
![Alt text](https://cloud.githubusercontent.com/assets/22662617/22574012/16c189fc-e97a-11e6-8dac-c5e8664636d1.jpg)
 * The app uses the Google Maps SDK for iOS to display user locations on an actual map.
 * The marker on the map tells the user how many hours he spent at the place along with his employee code.

#### 4. Sending data to server
 * The app sends the following data to the server in the form of JSON object-
  * Employee code
  * Latitude of location object
  * Longitude of location object
  * Timestamp of location object
  * Distance travelled by user
  * Time spent at location
 * If the device is not connected to the internet, the app stores data locally and sends it all together upon reconnection.

***

#### Limitations of current version
 * A server has not been setup to store locations. So the function call to send data to server has been commented out.
 * Since the current version is not hooked up to an employee databse, it accepts any valid string of length greater than 1 as employee code and password for login.
 
