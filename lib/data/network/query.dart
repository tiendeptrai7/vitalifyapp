String loginQuery = """
 mutation login (\$input:LoginCondition!) {
      login(condition:\$input) {
        token
        token_type
        expires_in
        user {
          userId
          vfaJoinedDate
          vfaEmail
        }
      }
}
  """;

String checkQuery = """
mutation createActivity(\$input: CreateActivityCondition!) {
  createActivity(condition: \$input) {
    requestResolved
    message
    errorCode
    createdAt
  }
}

""";

String myTimeLine = """
  query myTimeLine(\$input: MyTimeLineCondition) {
    myTimeLine(condition: \$input) {
      response {
        groupDate
        collections {
          activityTypes
          activityDescription
        }
      }
      error {
        requestResolved
        message
        errorCode
      }
    }
  }
  """;

String registerQuery(
    String lastname,
    String name,
    String middlename,
    String phone,
    String address,
    String email,
    String password,
    String confirmpassword) {
  return """mutation {
  register(registerInput:{
    lastname:"$lastname"
    name:"$name"
    middlename:"$middlename"
    phone:"$phone"
    address:"$address"
    email:"$email",
    password:"$password"
    confirmPassword:"$confirmpassword"
  })
}""";
}

getUser() {
  return """{
  user(id:1){
    id
    userName
    email
    counterpartyId
  }
}""";
}
