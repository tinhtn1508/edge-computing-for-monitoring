const db = require("./config/dbConfig.js");

// GET ALL config
const find = () => {
  return db("config");
};

const addConfig = config => {
  return db("config").insert(config, "id");
};

const test = async () => {
  const a = await addConfig({
    "key": "HEHE",
    "value": 100
  })
  console.log(a)
}


test()