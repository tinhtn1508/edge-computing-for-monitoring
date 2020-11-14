const router = require("express").Router();

const configDB = require("../models/config-model.js");

// GET ALL config
router.get("/", async (req, res) => {
  try {
    const config = await configDB.find();
    res.status(200).json(config);
  } catch (err) {
    res.status(500).json({ err: err });
  }
});

// GET USER BY ID
router.get("/:id", async (req, res) => {
  const configId = req.params.id;
  try {
    const config = await configDB.findById(configId);
    if (!config) {
      res
        .status(404)
        .json({ err: "The config with the specified id does not exist" });
    } else {
      res.status(200).json(config);
    }
  } catch (err) {
    res.status({ err: "The config information could not be retrieved" });
  }
});

// INSERT USER INTO DB
router.post("/", async (req, res) => {
  const newConfig = req.body;
  if (!newConfig.key) {
    res.status(404).json({ err: "Please provide the key" });
  } else {
    try {
      const config = await configDB.addConfig(newConfig);
      res.status(201).json(config);
    } catch (err) {
      res.status(500).json({ err: "Error in adding config" });
    }
  }
});

router.put("/:id", async (req, res) => {
  const configId = req.params.id;
  const newChanges = req.body;
  if (!newChanges.name) {
    res.status(404).json({ err: "You are missing information" });
  } else {
    try {
      const addChanges = await configDB.updateUser(configId, newChanges);
      res.status(200).json(addChanges);
    } catch (err) {
      res.status(500).json({ err: "Error in updating config" });
    }
  }
});

router.delete("/:id", async (req, res) => {
  const configId = req.params.id;
  try {
    const deleting = await configDB.removeUser(configId);
    res.status(204).json(deleting);
  } catch (err) {
    res.status(500).json({ err: "Error in deleting config" });
  }
});

module.exports = router;
