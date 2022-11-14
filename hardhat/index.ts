import dotenv from "dotenv"

const envPath = __dirname + '\\.env_template';
dotenv.config({path: envPath, debug: true});
console.log(process.env.NAME);
