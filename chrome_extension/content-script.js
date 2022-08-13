let targetUrl = window.location.href;
const isoDateString = new Date().toISOString();

const myHeaders = new Headers({
  'Content-Type': 'application/json',
  'Authorization': 'haSiFxuWvwf8B2nLg2cM',
  'X-User-Email': "fake@fake.me"
});

const notifications = {
  "notification":
  {
      "accessed_at": isoDateString,
      "read": false,
      "description": `Accessed ${targetUrl}`
  },

  "site":
  {
    "url": `${targetUrl}`,
    "reason": `Accessed ${targetUrl}`,
    "referral_site": `${targetUrl}`
  }
}

// create an object to store the risk score
let risk_score = 0;

const riskRequest = new Request('https://www.notsofast.co/api/v1/sites/risk-check', {
  method: 'POST',
  headers: myHeaders,
  body: JSON.stringify(notifications.site)
 });

fetch(riskRequest)
  .then(checkStatus)
  .then(response => response.json())
  .then(data => {
    if (data.risk_score > 1) {
      createNotification();
    };
  })
  .catch((error) => {
    console.log('There was an error', error);
});

const request = new Request('https://www.notsofast.co/api/v1/notifications', {
  method: 'POST',
  headers: myHeaders,
  body: JSON.stringify(notifications)
 });

// if risk score is more than 5 then fetch

function createNotification() {
  fetch(request)
    .then(checkStatus)
    .then(response => response.json())
    .then(data => {
      console.log(data);
    })
    .catch((error) => {
      console.log('There was an error', error);
    });
}

function checkStatus(response) {
  if (response.ok) {
      return response;
  }

  let error = new Error(response.statusText);
  error.response = response;
  return Promise.reject(error);
}
