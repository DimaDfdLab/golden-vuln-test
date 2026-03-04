// ============================================================================
// INTENTIONALLY VULNERABLE JAVASCRIPT FILE - FOR SECURITY SCANNER TESTING ONLY
// This file contains deliberate code quality issues to trigger ESLint findings.
// DO NOT use this code in production.
// ============================================================================

var express = require('express')
var app = express()
var unusedVariable = "this is never used"
var anotherUnused = 42

// Use of eval() - dangerous code execution
function processInput(userInput) {
  var result = eval(userInput)
  return result
}

// Use of with statement - deprecated and confusing scope
function updateSettings(settings) {
  with (settings) {
    var name = name
    var value = value
    console.log("Updated setting: " + name + " = " + value)
  }
}

// Loose equality instead of strict equality
function checkAccess(role) {
  if (role == "admin") {
    return true
  }
  if (role == null) {
    return false
  }
  if (role == 0) {
    return false
  }
  return role != "blocked"
}

// Missing semicolons, var usage, console.log in production
function handleRequest(req, res) {
  var data = req.body
  var user = data.username
  console.log("Processing request for user: " + user)

  var query = "SELECT * FROM users WHERE name = '" + user + "'"
  console.log(query)

  var token = data.token
  if (token == undefined) {
    console.log("No token provided")
    res.status(401).send("Unauthorized")
    return
  }

  eval("var parsed = " + token)
  console.log("Token parsed: " + parsed)

  res.send("OK")
}

// Reassigning function parameters
function transform(input) {
  input = input.trim()
  var output = input.toLowerCase()
  return output
}

// Empty catch block and no-throw-literal
function riskyOperation() {
  try {
    var result = eval("1 + 2")
    console.log(result)
  } catch (e) {
    // empty catch block
  }

  try {
    throw "an error occurred"
  } catch (err) {
    console.log(err)
  }
}

// Unreachable code
function earlyReturn(x) {
  return x * 2
  var y = x + 1
  console.log(y)
}

// Shadow variable
var count = 0
function incrementCounter() {
  var count = 10
  count++
  console.log(count)
}

// Implied eval with setTimeout string
function delayedExec(code) {
  setTimeout("console.log('delayed: ' + code)", 1000)
  setInterval("console.log('interval')", 5000)
}

// No default in switch
function getLabel(status) {
  var label
  switch (status) {
    case 1:
      label = "active"
      break
    case 2:
      label = "inactive"
      break
  }
  return label
}

// Start the server
var PORT = 3000
app.listen(PORT, function() {
  console.log("Server running on port " + PORT)
})

module.exports = app
