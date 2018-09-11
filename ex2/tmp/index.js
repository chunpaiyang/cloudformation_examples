
exports.handler = async function(event, context) {
   console.log("value1 = " + event.key1);
   console.log("value2 = " + event.key2);
   return "some success message";
}
