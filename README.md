# Overview
This small (command line) program is used to 

* retrieve all folder icons and store it in PNG files corresponding to their folder names
* set folder icons previously stores by this program (or manually)
* shows you how to do this if you read the code.

I wrote this tool for myself to make an feasable backups of my [BoxerApp](http://www.boxerapp.com) game bundle covers.

# Example
This is a command line program tool with a normal common unix help

```
foldericon (get|set) <folder1> [ <folder2> ... ]

    get:
       this program stores the folder icon of the given in folder(s)
       to the current directory

    set:
       this program restores the folder icon(s) of the given in folder(s)
       from the current directory
```
all the retrieved images are stored in the current folder in which you call the program. It is a wise choice to create an icon folder and change the directory.

The program works with one folder, but also with multiple folders:
* ```get ~/DOS\ Games.localized/MyGame.boxer``` - one folder
* ```get ~/DOS\ Games.localized/MyGame.boxer/*``` - all folders inside (```*``` as shell globber)

#### Retrieving the image of a given directory

Create an folder ```test```

```
foldericon get test
```
storing the normal icon of an folder in file ```test.png```.


#### Retrieving the image of an application

An application is also a folder in MacOS with extension ```app```

```
foldericon get /Applications/Calculator.app
```
storing the Icon of the application Calculator in file ```Calculator.app.png```.


#### Retrieving the image of a Boxer app bundle

A Boxer app bundle is also a folder in MacOS with extension ```boxer```

```
foldericon get ~/DOS\ Games.localized/MyGame.boxer
```
storing the Icon of the application Calculator in file ```MyGame.boxer.png```.

#### Setting the image of a Boxer app bundle

You need the previously stored image(s) and call the program as follows
```
foldericon set ~/DOS\ Games.localized/MyGame.boxer
```
The program tries to read the local file ```MyGame.boxer.png``` and stores its icon as the folder icon of the given path ```~/DOS\ Games.localized/MyGame.boxer```.