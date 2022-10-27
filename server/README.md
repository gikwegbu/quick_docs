## Things to Install

1. npm i express http socket.io@2.3.0 jsonwebtoken mongoose
2. npm i nodemon --save-dev
3. npm install --save dotenv
4. npm install cors


## Create a .gitignore file

1. ignore the node_modules in the .gitignore file


## PORT Config
When creating the port, use either the process.env.PORT if available (i.e will be available when you host the app) or 3001. Also, pass '0.0.0.0' into the app.listen(), as a wildcard to accept any ip address that wants to access the endpoints...

## Safe Guarding your Database Credentials with dotenv(gd27cAq9qBnaU5qtnikwegbu)
1. Install the dotenv package first of all.
2. Create a .env file and store your credentials, username=kdfakdkfa password=lkasdjfkads
3. Require the dotenv package in your mongoose file, 
4. Initiate the dotenv.config(), to expose your environment variables in the mongoose file.
5. using process.env.username and process.env.password, to utilize the credentials stored in the environment variables.

## Installing Cors
The Cross-origin resource sharing error, happens when one computer from another domain (localhost:3000) is trying to get resources hosted on another domain (http://www.lol.com:5938). To avert this, 

1. Install the cors package.
2. Require it in the index.js, where the express app is running.
3. Add app.use(cors()), to your middlewares, just before the app.use(express.json()).
