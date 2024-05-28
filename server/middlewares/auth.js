const jwt = require("jsonwebtoken");
const auth = async (req, res, next) => {
  try {

      const token = req.headers["authtoken"]
      if (!token) {
          return res.status(401).send('No token')
      }
      const verified = jwt.verify(token, 'jwtsecret')
      
      if (!verified)
      return res
        .status(401)
        .json({ msg: "Token verification failed, authorization denied." });
      req.user = verified.user.id
      req.token = token;
      console.log(req.user)

      
      next();
  } catch (err) {
      
      console.log(err)
      res.send('Token Invalid').status(500)
  }
}


module.exports = auth;
