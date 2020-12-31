require("dotenv").config();
const server = require("./server");
console.log(process.env)

const port = process.env.PORT || 5000;

server.listen(port, () => console.log(`API running on port ${port}`));
