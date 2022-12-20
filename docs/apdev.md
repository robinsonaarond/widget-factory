# SETUP

## Setting up the repo
1. Install **moxiworks/apdev.git** ([github](https://github.com/moxiworks/apdev)).
```
git clone git@github.com:moxiworks/apdev.git
cd apdev
./install.sh
```
2. (Optional) Install **lazydocker** to keep track of docker containers ([github](https://github.com/moxiworks/apdev/blob/master/README.md#use-with-lazydocker)).
3. Clone **widget-factory**:
```
git clone git@github.com:moxiworks/widget-factory
cd widget-factory
```
4. From the `widget-factory` directory, add the repo to apedv and setup the **widget-factory** service:
```
apdev add .
apdev setup
```

## Running the application
Start the **widget-factory** service for development:
```
apdev start widget-factory
```
 will be accessible on [30013](http://localhost:30013)

## Helpful commands
Run `apdev help` for a list of helpful commands.
