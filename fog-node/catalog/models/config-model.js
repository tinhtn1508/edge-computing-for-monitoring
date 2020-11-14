const db = require("../config/dbConfig.js");

// GET ALL config
const find = () => {
  return db("config");
};

// GET SPECIFIC CONFIG BY ID
const findById = id => {
  return db("config").where("id", id);

  //SQL RAW METHOD
  // return db.raw(`SELECT * FROM config
  //                  WHERE id = ${id}`);
};

// ADD A CONFIG
const addConfig = config => {
  return db("config").insert(config, "id");
};

// UPDATE CONFIG
const updateConfig = (id, post) => {
  return db("config")
    .where("id", id)
    .update(post);
};

// REMOVE CONFIG
const removeConfig = id => {
  return db("config")
    .where("id", id)
    .del();
};

module.exports = {
  find,
  findById,
  addConfig,
  updateConfig,
  removeConfig
};
