#include <BleKeyboard.h>
BleKeyboard bleKeyboard;
#include <MPU6050.h> // library for working with accelerometer 
const int MPU_addr = 0x68; // I2C address MPU-6050
int16_t AcX, AcY, AcZ, Tmp, GyX, GyY, GyZ; // variables for data 

void setup() {
Serial.begin(115200); // connect com port, set speed
Serial.println("Starting BLE work!");
bleKeyboard.begin();
Wire.begin();                                    // 
Wire.beginTransmission(MPU_addr);                //
Wire.write(0x6B); // PWR_MGMT_1 register
Wire.write(0); // set to zero (wakes up MPU-6050)
Wire.endTransmission(true); }

void loop() {
Wire.beginTransmission(MPU_addr);
Wire.write(0x3B); // starting from register 0x3B (ACCEL_XOUT_H)
Wire.endTransmission(false);
Wire.requestFrom(MPU_addr, 14, true); // request a total of 14 registers
AcX = Wire.read() << 8 | Wire.read();            // 0x3B (ACCEL_XOUT_H) & 0x3C (ACCEL_XOUT_L)
AcY = Wire.read() << 8 | Wire.read();            // 0x3D (ACCEL_YOUT_H) & 0x3E (ACCEL_YOUT_L)
AcZ = Wire.read() << 8 | Wire.read();            // 0x3F (ACCEL_ZOUT_H) & 0x40 (ACCEL_ZOUT_L)
Tmp = Wire.read() << 8 | Wire.read();            // 0x41 (TEMP_OUT_H) & 0x42 (TEMP_OUT_L)
GyX = Wire.read() << 8 | Wire.read();            // 0x43 (GYRO_XOUT_H) & 0x44 (GYRO_XOUT_L)
GyY = Wire.read() << 8 | Wire.read();            // 0x45 (GYRO_YOUT_H) & 0x46 (GYRO_YOUT_L)
GyZ = Wire.read() << 8 | Wire.read();            // 0x47 (GYRO_ZOUT_H) & 0x48 (GYRO_ZOUT_L)
delay(50); // sensor polling rate
                                       
if ( AcX > 5000)  {                             // W
bleKeyboard.press(119); }
if ( AcY > 5000 )  {                            // A
bleKeyboard.press(97); }
if  ( AcX < -5000) {                            // S
bleKeyboard.press(115); }
if  ( AcY < -5000)  {                           // D
bleKeyboard.press(100); }

if ( AcX < 5000)  {                             // W
bleKeyboard.release(119); }
if ( AcY < 5000 )  {                            // A
bleKeyboard.release(97); }
if  ( AcX > -5000) {                            // S
bleKeyboard.release(115); }
if  ( AcY > -5000)  {                           // D
bleKeyboard.release(100); }

if ( ( AcX > 5000) && ( AcY > 5000 )  ) {       // W A
bleKeyboard.press(97); 
bleKeyboard.press(119); }
if ( ( AcX > 5000) && ( AcY > -5000)  ) {       // W D
bleKeyboard.release(100); 
bleKeyboard.press(119); }

Serial.print(" | AcXX = "); Serial.print(GyX); // we observe the readings through the compass
Serial.print(" | AcXY = "); Serial.print(GyY); // we observe the readings through the compass
Serial.print(" | AcXZ = "); Serial.println(GyZ); // we observe the readings through the compass

} // end