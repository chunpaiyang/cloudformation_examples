
exports.handler = async function(event, context) {
   console.log("value1 = " + event.key1);
   console.log("value2 = " + event.key2);
   console.log("hello");
   console.log("ex5");
   return "some success message";
}
