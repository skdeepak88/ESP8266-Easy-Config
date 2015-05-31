# ESP-Flexi-Config
Configure your ESP module from the browser

After uploading all the files reboot your ESP module to enter AP mode. Connect to ESPSensor network with the password opendoor and then visit 192.168.4.1 you wil be presented with a simple form. Enter SSID and Password of your WiFi network. The configuration is done! Note you wont be presented with any error if you typed your password wrong. Its not very hard to implement but the challenge is memory management.

Once configured reboot the module to boot into your network. 

Look at httpfunctions.lua file to decide what your module should do. I am posting it to dweet.io. Feel free to modify the code that suit your needs.

Note: I am running the code on NodeMCU 0.9.5 build 20150214  powered by Lua 5.1.4. The heap memory after installing all these files will be too little so have that in mind while editing the code. The code may not be very perfect as this is my firs attempt and only 2 days of learning lua. So use at your own risk ;) 

I am running the code on Ray's ESPToy and used his startup demo as the starting point to learn lua. 

More info on the product can be found here http://rayshobby.net/esptoy/

His demo script can be found here https://github.com/rayshobby/esptoy
