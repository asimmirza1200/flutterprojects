const PAYMENT_URL =
    "https://us-central1-lessonhub-1e8ac.cloudfunctions.net/customFunctions/payment";

const ORDER_DATA = {
  "custID": "USER_1122334455",
  "custEmail": "someemail@gmail.com",
  "custPhone": ""
};

const STATUS_LOADING = "PAYMENT_LOADING";
const STATUS_SUCCESSFUL = "PAYMENT_SUCCESSFUL";
const STATUS_PENDING = "PAYMENT_PENDING";
const STATUS_FAILED = "PAYMENT_FAILED";
const STATUS_CHECKSUM_FAILED = "PAYMENT_CHECKSUM_FAILED";
